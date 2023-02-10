# frozen_string_literal: true

class HomeController < BeyondCanvas::AuthenticationsController
  breadcrumb 'Home', :root_path

  def index; end
end
