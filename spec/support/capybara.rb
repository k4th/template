# frozen_string_literal: true

# NOTE: Set `CAPYBARA_JAVASCRIPT_DRIVER` environment variable to `selenium_chrome` if you want to see the browser during
#       the test suite

Capybara.javascript_driver = ENV.fetch('CAPYBARA_JAVASCRIPT_DRIVER', :selenium_chrome_headless).to_sym
Capybara.default_max_wait_time = 15
Capybara.server = :puma, { Silent: true }
Capybara.app_host = ENV.fetch('TEST_COCKPIT_URL')
Capybara.run_server = true
Capybara.server_port = ENV.fetch('TEST_SERVER_PORT', 5000).to_i
