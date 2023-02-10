# frozen_string_literal: true

class CockpitTestHelper < Capybara::TestHelper
  use_test_helpers(:form)

  def fill_in_login_form
    # go to cockpit login
    visit '/login'

    # set user and password
    fill_in 'username', with: ENV.fetch('TEST_COCKPIT_USERNAME')
    fill_in 'password', with: ENV.fetch('TEST_COCKPIT_PASSWORD')

    # click on log in button
    find('button[type="submit"]').click
  end

  def go_to_dummy_app
    fill_in_login_form

    # click on apps menu
    find('a[data-sidebar-id="mainMenu.apps"]').click

    # click on custom apps
    find('a[data-sidebar-id="mainMenu.apps.customApps"]').click

    # click on export app
    find(:xpath, "//a[@href='#{ENV.fetch('TEST_CUSTOM_APP_URL')}']").click
  end

  def test_authorization
    page.find('button', class: /Button__outline/i).click
    sleep 1
  end
end
