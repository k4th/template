# frozen_string_literal: true

FactoryBot.define do
  # FactoryBot.build(:shop)
  ##############################################################################
  factory :shop, class: Shop do
    sequence(:beyond_access_token) { |n| "beyond_access_token_#{n}" }
    sequence(:beyond_refresh_token) { |n| "beyond_refresh_token_#{n}" }
    sequence(:beyond_api_url) { |n| "beyond_api_url_#{n}" }
    sequence(:beyond_reseller) { |n| "beyond_reseller_#{n}" }
    sequence(:beyond_shared_secret) { |n| "beyond_shared_secret#{n}" }
  end
end
