# frozen_string_literal: true

require 'beyond_canvas/version'
require 'beyond_canvas/engine'

require 'beyond_api'
require 'bourbon'
require 'dry-initializer'
require 'http/accept'
require 'sassc-rails'
require 'inline_svg'
require 'premailer/rails'
require 'loaf'
require 'view_component'

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/component_previews")
loader.setup

module BeyondCanvas
  extend Setup
end

loader.reload
