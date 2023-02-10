# frozen_string_literal: true

module BeyondCanvas
  class FormBuilder < ActionView::Helpers::FormBuilder # rubocop:disable Metrics/ClassLength
    include ActionView::Helpers::SanitizeHelper

    [:email_field, :text_field, :number_field, :password_field, :text_area].each do |method|
      define_method method do |attribute, args = {}|
        field_wrapper(attribute, args) do
          super(attribute, args)
        end
      end
    end

    def select(attribute, choices, options = {}, args = {})
      field_wrapper(attribute, args) do
        super(attribute, choices, options, args)
      end
    end

    def check_box(attribute, args = {}, checked_value = '1', unchecked_value = '0')
      field_identifyer = field_identifyer(attribute)

      inline_wrapper(attribute, args, field_identifyer) do
        args.merge!(id: field_identifyer)
            .merge!(hidden: true)
            .merge!(class: 'input__checkbox')

        super(attribute, args, checked_value, unchecked_value) +
          @template.content_tag(:label, class: 'input__checkbox__control', for: field_identifyer) do
            @template.inline_svg_tag('icons/checkbox_checked.svg', style: 'display: none;',
                                                                   class: 'input__checkbox--checked') +
              @template.inline_svg_tag('icons/checkbox_unchecked.svg', style: 'display: none;',
                                                                       class: 'input__checkbox--unchecked')
          end
      end
    end

    def radio_button(attribute, value, args = {})
      field_identifyer = field_identifyer(attribute)

      inline_wrapper(attribute, args, field_identifyer) do
        args.merge!(id: field_identifyer)
            .merge!(hidden: true)
            .merge!(class: 'input__radio')

        super(attribute, value, args) +
          @template.content_tag(:label, class: 'input__radio__control', for: field_identifyer) do
            @template.inline_svg_tag('icons/radiobutton_checked.svg', style: 'display: none;',
                                                                      class: 'input__radio--checked') +
              @template.inline_svg_tag('icons/radiobutton_unchecked.svg', style: 'display: none;',
                                                                          class: 'input__radio--unchecked')
          end
      end
    end

    def file_field(attribute, args = {})
      field_wrapper(attribute, args) do
        field_identifyer = field_identifyer(attribute)

        stimulus_action = 'file-input#display'
        stimulus_action += " #{args[:data][:action]}" if args[:data] && args[:data][:action]

        args.merge!(id: field_identifyer)
            .merge!(style: 'visibility: hidden; position: absolute;')
            .merge!(data: { action: stimulus_action, 'file-input-target': 'input' })

        custom_attributes = { data: { multiple_selection_text: '{count} files selected' } }
        args = custom_attributes.merge!(args)

        @template.content_tag(:div, class: 'input__file', data: { controller: 'file-input' }) do
          super(attribute, args) +
            @template.content_tag(:label,
                                  for: field_identifyer,
                                  class: 'input__file__control button__transparent--primary') do
              args[:data][:button_text] || 'Choose file'
            end +
            @template.content_tag(:span,
                                  args[:data][:no_file_text] || 'No file chosen',
                                  class: "input__file__text #{field_identifyer}",
                                  data: { 'file-input-target': 'value' })
        end
      end
    end

    # IMPORTANT: Using this method inside a form_for block
    # will set the enclosing form's encoding to multipart/form-data.
    def image_file_field(attribute, args = {}, &block)
      self.multipart = true # SEE: https://api.rubyonrails.org/v6.1.0/classes/ActionView/Helpers/FormBuilder.html#method-i-file_field

      image_field_wrapper(attribute, args) do
        field_identifyer = field_identifyer(attribute)

        args.merge!(id: field_identifyer)
            .merge!(style: 'visibility: hidden; position: absolute;')
            .merge!(data: { action: 'image-file-input#display', 'image-file-input-target': 'input' })

        @template.content_tag(:div, class: 'attachments', js_identifier: field_identifyer,
                                    data: { 'image-file-input-target': 'content' }) do
          image = @object.send(attribute)
          [
            (block.call if block_given?)
          ].compact.inject(:+)
          [
            (image_placeholder(args) unless image_exist?(attribute))
          ].compact.inject(:+)
        end +
          @template.content_tag(:div, class: 'input__file') do
            @template.file_field(@object_name, attribute, {}.merge(args)) +
              @template.content_tag(:label,
                                    for: field_identifyer,
                                    class: 'input__file__control button__transparent--primary') do
                if image_exist?(attribute)
                  args.dig(:data,
                           :button_change_text) || 'Change image'
                else
                  args.dig(:data,
                           :button_upload_text) || 'Upload image'
                end
              end
          end
      end
    end

    private

    def field_wrapper(attribute, args, &block) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      label = sanitize(args.delete(:label))
      hint = sanitize(args.delete(:hint))
      pre = args.delete(:pre)
      post = args.delete(:post)

      if object.respond_to?(:errors) && object.errors.include?(attribute)
        errors = object.errors[attribute].join(BeyondCanvas.configuration.model_errors_joined_by)
      end

      @template.content_tag(:div, class: 'form__row') do
        [
          (@template.content_tag(:label, label, class: 'input__label') if label.present?),
          (@template.content_tag(:div, class: 'relative', style: ('display: flex;' if pre || post).to_s) do
            [
              (@template.content_tag(:span, pre, class: 'input__pre') if pre.present?),
              (@template.content_tag(:span, post, class: 'input__post') if post.present?),
              block.call,
              (@template.content_tag(:label, errors, class: 'input__error') if errors.present?)
            ].compact.inject(:+)
          end),
          (@template.content_tag(:div, hint, class: 'input__hint') if hint.present?)
        ].compact.inject(:+)
      end
    end

    def inline_wrapper(attribute, args, field_identifyer, &block) # rubocop:disable Metrics/CyclomaticComplexity
      label = sanitize(args.delete(:label))
      hint = sanitize(args.delete(:hint))
      if object.respond_to?(:errors) && object.errors.include?(attribute)
        errors = object.errors[attribute].join(BeyondCanvas.configuration.model_errors_joined_by)
      end

      @template.content_tag(:div, class: 'form__row') do
        @template.content_tag(:div, class: 'relative', style: 'display: flex; align-items: center;') do
          block.call +
            (if label.present? || hint.present?
               @template.content_tag(:div) do
                 [
                   (if label.present?
                      @template.content_tag(:label, label, class: 'input__label',
                                                           for: field_identifyer)
                    end),
                   (@template.content_tag(:label, hint, class: 'input__hint', for: field_identifyer) if hint.present?)
                 ].compact.inject(:+)
               end
             end) +
            (@template.content_tag(:label, errors, class: 'input__error') if errors.present?)
        end
      end
    end

    def field_identifyer(attribute)
      "#{attribute}_#{DateTime.now.strftime('%Q') + rand(10_000).to_s}"
    end

    def image_placeholder(args)
      placeholder_with = 300
      placeholder_height = 300
      placeholder_with, placeholder_height = args[:placeholder_size].split('x') if args[:placeholder_size].present?
      html_options = {
        class: 'attachment attachment__placeholder',
        style: "width:#{placeholder_with}px;height:#{placeholder_height}px;",
        data: {
          'image-file-input-target': 'placeholder'
        }
      }

      @template.content_tag(:figure, html_options) do
        @template.inline_svg_tag('icons/placeholder.svg')
      end
    end

    def image_exist?(attribute)
      image = @object.send(attribute)

      image.attached?
    end

    def image_field_wrapper(attribute, args, &block)
      label = sanitize(args.delete(:label))
      hint = sanitize(args.delete(:hint))
      pre = args.delete(:pre)
      post = args.delete(:post)

      if object.respond_to?(:errors) && object.errors.include?(attribute)
        errors = object.errors[attribute].join(BeyondCanvas.configuration.model_errors_joined_by)
      end

      @template.content_tag(:div, class: 'form__row', data: { controller: 'image-file-input' }) do
        [
          (@template.content_tag(:label, label, class: 'input__label') if label.present?),
          (@template.content_tag(:div, hint, class: 'input__hint', style: 'margin-bottom: 10x') if hint.present?),
          (@template.content_tag(:div, class: 'relative', style: ('display: flex;' if pre || post).to_s) do
            [
              (@template.content_tag(:span, pre, class: 'input__pre') if pre.present?),
              (@template.content_tag(:span, post, class: 'input__post') if post.present?),
              block.call,
              (@template.content_tag(:label, errors, class: 'input__error') if errors.present?)
            ].compact.inject(:+)
          end)
        ].compact.inject(:+)
      end
    end
  end
end
