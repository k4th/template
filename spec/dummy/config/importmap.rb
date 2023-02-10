# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js'
pin_all_from BeyondCanvas::Engine.root.join('app/assets/javascripts/beyond_canvas/controllers'),
             under: 'controllers', to: 'beyond_canvas/controllers'
