# frozen_string_literal: true

class BeyondCanvasCreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :beyond_api_url, null: false, unique: true
      t.string :beyond_reseller
      t.text   :beyond_access_token
      t.text   :beyond_refresh_token
      t.text   :beyond_shared_secret

      t.timestamps
    end

    add_index :shops, :beyond_api_url, unique: true
  end
end
