class AddTokenToCreditCardSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_card_settings, :token, :string
  end
end
