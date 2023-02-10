# frozen_string_literal: true

module BeyondCanvas
  module Models
    module Concerns
      module Authentication
        extend ActiveSupport::Concern

        included do
          validates :beyond_api_url,
                    presence: true

          validates :beyond_reseller,
                    presence: true

          validates :beyond_access_token,
                    presence: true,
                    if: -> { beyond_access_token_was.present? }

          validates :beyond_refresh_token,
                    presence: true,
                    if: -> { beyond_refresh_token_was.present? }

          encrypts :beyond_access_token
          encrypts :beyond_refresh_token
        end

        def authenticated?
          beyond_access_token.present? &&
            (BeyondCanvas.client_credentials? || beyond_refresh_token.present?)
        end

        def authenticate(code)
          session = to_session

          if BeyondCanvas.client_credentials?
            session.token.client_credentials
          else
            session.token.authorization_code(code)
          end

          assign_attributes(beyond_access_token: session.access_token,
                            beyond_refresh_token: session.refresh_token)

          self
        end

        def authenticate!(code)
          authenticate(code)

          save!
        end

        def set_reseller
          reseller = to_session.shop.current[:reseller_name]

          assign_attributes(beyond_reseller: reseller)

          reseller
        end

        def set_reseller!
          set_reseller

          save!
        end
      end
    end
  end
end
