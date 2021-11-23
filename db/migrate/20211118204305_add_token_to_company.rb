class AddTokenToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :token, :string, unique: true, default: ''
  end
end
