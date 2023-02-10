# frozen_string_literal: true

require_relative 'lib/beyond_canvas/version'

Gem::Specification.new do |spec|
  spec.name        = 'beyond_canvas'
  spec.version     = BeyondCanvas::VERSION
  spec.homepage    = 'https://github.com/k4th/template'
  spec.summary     = 'Open-source framework'
  spec.authors     = ['Unai', 'Kathia', 'German']
  spec.email       = 'team-42@epages.com'
  spec.description = <<-DESC
    Beyond Canvas is an open-source framework that provides base functionality for apps
    designed and developed for ePages Beyond Shops
  DESC
  spec.license = 'MIT'

  spec.metadata['homepage_uri']          = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = '>= 3.1'

  spec.add_development_dependency 'rspec-rails',   '~> 5.1'
  spec.add_development_dependency 'rubocop',       '~> 1.30'
  spec.add_development_dependency 'rubocop-rails', '~> 2.14'

  spec.add_dependency 'beyond_api'
  spec.add_dependency 'bourbon',          '~> 7.2'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'http-accept',      '~> 2.1'
  spec.add_dependency 'inline_svg'
  spec.add_dependency 'jwt',              '~> 2.4'
  spec.add_dependency 'loaf'
  spec.add_dependency 'premailer-rails',  '~> 1.8'
  spec.add_dependency 'rails',            '>= 7.0.3'
  spec.add_dependency 'sassc-rails',      '~> 2.1'
  spec.add_dependency 'view_component',   '~> 2.79'
  spec.add_dependency 'zeitwerk',         '~> 2.5'
end
