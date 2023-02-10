# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:beyond_api_url) }
      it { is_expected.to validate_presence_of(:beyond_reseller) }
      it { is_expected.to_not validate_presence_of(:beyond_access_token) }
      it { is_expected.to_not validate_presence_of(:beyond_refresh_token) }
    end

    describe 'presence of beyond tokens if they were previously set' do
      subject { FactoryBot.create(:shop) }

      it { is_expected.to validate_presence_of(:beyond_access_token) }
      it { is_expected.to validate_presence_of(:beyond_refresh_token) }
    end
  end
end
