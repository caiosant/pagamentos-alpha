class AddTypeOfToPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :type_of, :integer, default: 0
  end
end
