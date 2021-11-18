class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.decimal :fee
      t.decimal :maximum_fee

      t.timestamps
    end
  end
end
