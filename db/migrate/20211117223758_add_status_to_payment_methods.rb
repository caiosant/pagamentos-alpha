class AddStatusToPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :status, :integer, default: 5
  end
end
