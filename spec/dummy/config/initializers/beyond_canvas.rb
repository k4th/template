# frozen_string_literal: true

BeyondCanvas.setup do |config|
  # Carefully read and fill this configuration file.
  #
  # All uncommented configuration parameters are necessary for proper operation
  # of Beyond Canvas.

  # ==> Engine configuration

  # Set the url or path where a shop is going to be redirected after a
  # succesful authorization.
  #
  config.open_app_url = '/'

  # Set if your app ig going to run as a cockpit app. If you are not sure about
  # this, please contact apps@epages.com.
  #
  config.cockpit_app = true

  # Set if you want to enable the automatic CSS style management based on the
  # shop's `reseller_name`. If you are not sure about this, please contact
  # apps@epages.com.
  #
  # config.custom_styles = false

  # Set if you want to enable the available debug mode Beyond Canvas offers.
  # This option displays a parameter debug as well as some custom Beyond Canvas
  # logs.
  #
  # config.debug_mode = false

  # ==> Authorization configuration

  # Set if you want to retrieve the shop token using `grant_type=client_credentials`.
  # This option will only work on development environment. Default is
  # `grant_type=authorization_code`.
  #
  config.client_credentials = false

  # ==> Site configuration

  # Set the title that is displayed on the application layout's <head>'s title.
  #
  config.site_title = 'Dummy App'

  # Set an optional image to be displayed instead of a string. Accepts any
  # string supported by image_tag's source parameter or a SVG file. Overrides
  # :site_title.
  #
  # config.site_logo = 'logo.svg'

  # Set the favicon of the site.
  #
  # config.favicon = 'favicon.ico'

  # Set an optional image to be send on email headers. Accepts any string
  # supported by `image_tag`'s source parameter. Overrides :email_logo.
  #
  # config.email_logo = 'logo.png' # Can't be svg

  # ==> Webhooks

  # By default Beyond Canvas subscribes to `app.uninstalled` and `app.deleted`
  # webhook events and handles the uninstallation and deletion of an app.
  #
  # If you want to subscribe to any of the existing webhooks (`product.created`,
  # `product.updated`, `order.created`, `order.updated`) apart from
  # `app.uninstalled` and `app.deleted` on app installation process, add them
  # like follows:
  #
  # To subscribe to a single webhook event:
  # config.register_webhook_event('product.created')
  #
  # To subscribe to multiple webhook events:
  # config.register_webhook_events('product.created', 'product.updated')

  # Set a URL where webhooks will call on non-production environments. You can
  # make use of https://webhook.site/.
  #
  # On production environments, the URL will be automatically generated.
  #
  config.webhook_site_url = 'test'
end
