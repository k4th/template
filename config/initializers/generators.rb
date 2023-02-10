# frozen_string_literal: true

BeyondCanvas::Engine.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end
