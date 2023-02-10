# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path('../../../Gemfile', __dir__) # rubocop:disable Style/StringLiterals

require 'bundler/setup' if File.exist?(ENV.fetch('BUNDLE_GEMFILE'))
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)
