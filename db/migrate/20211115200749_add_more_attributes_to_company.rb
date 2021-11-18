class AddMoreAttributesToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :status, :integer, default: 0
    add_column :companies, :billing_email, :string
    add_column :companies, :billing_address, :text
  end
end
