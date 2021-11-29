class AddTokenToBoletoSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :boleto_settings, :token, :string
  end
end
