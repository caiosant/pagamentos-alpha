class CreateCustomerPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_payment_methods do |t|
      t.references :payment_method, null: false, foreign_key: true
      t.string :credit_card_name
      t.string :credit_card_number
      t.date :credit_card_expiration_date
      t.string :credit_card_security_code
      t.references :company, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
