class AddTokenToPixSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :pix_settings, :token, :string
  end
end
