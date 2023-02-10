module BeyondCanvas
  class ApplicationComponent < ViewComponent::Base
    include Turbo::FramesHelper if Object.const_defined?('Turbo')
    extend Dry::Initializer
  end
end
