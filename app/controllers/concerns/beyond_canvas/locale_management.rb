# frozen_string_literal: true

module BeyondCanvas
  module LocaleManagement
    extend ActiveSupport::Concern

    included do
      around_action :switch_locale
    end

    private

    #
    # Sets the cookie locale as default locale if it is a valid locale. If it is not a valid locale, searches for a
    # browser compatible locale, sets the value to the cookie and set that locale as default locale.
    #
    def switch_locale(&action)
      unless valid_locale?(cookies[:locale])
        cookies[:locale] = locale_cookie_hash(app_locale)
      end

      I18n.with_locale(cookies[:locale], &action)
    end

    #
    # Checks if the given locale parameter is included on +I18n.available_locales+
    #
    def valid_locale?(locale)
      I18n.available_locales.map(&:to_s).include? locale
    end

    #
    # Returns the cookie hash for locale.
    #
    def locale_cookie_hash(locale)
      cookie_hash = {
        value: locale,
        expires: 1.year.from_now,
        secure: true
      }

      cookie_hash.merge!(same_site: :none) if BeyondCanvas.cockpit_app == true && !Rails.env.development?

      cookie_hash
    end

    #
    # If it is a cockpit app, it returns the shop default locale.
    # Otherwise it returns the browser compatible locale.
    #
    # @return [String] the local that the app will use (e.g. +'en-GB'+)
    #
    def app_locale
      BeyondCanvas.cockpit_app ? shop_locale : browser_compatible_locale
    end

    #
    # Retrieves the shop default locale from the Beyond API.
    #
    # @return [String] the shop default locale (e.g. +'en-GB'+)
    #
    def shop_locale
      locale = BeyondApi::Session.new(api_url: current_shop.beyond_api_url).shop.current[:default_locale]
      return locale if valid_locale?(locale)

      prefix = locale.split('-').first
      valid_locale?(prefix) ? prefix : browser_compatible_locale
    rescue StandardError
      browser_compatible_locale
    end

    #
    # Reads the +HTTP_ACCEPT_LANGUAGE+ header and searches a compatible locale
    # on +I18n.available_locales+. If no compatible language is found, it
    # returns +I18n.default_locale+.
    #
    # @return [String] a browser compatible language string or
    #   +I18n.default_locale+. (e.g. +'en-GB'+)
    #
    def browser_compatible_locale
      return I18n.default_locale if request.headers['HTTP_ACCEPT_LANGUAGE'].blank?

      browser_locales = HTTP::Accept::Languages.parse(request.headers['HTTP_ACCEPT_LANGUAGE'])
      available_locales = HTTP::Accept::Languages::Locales.new(I18n.available_locales.map(&:to_s))

      locales = available_locales & browser_locales

      locales.empty? ? I18n.default_locale : locales.first
    rescue StandardError
      I18n.default_locale
    end
  end
end
