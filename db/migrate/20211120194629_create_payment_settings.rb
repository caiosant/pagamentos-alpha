class CreatePaymentSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_settings do |t|
      t.references :company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.string :pix_key
      t.string :bank_code
      t.string :company_code
      t.string :agency_number
      t.string :account_number
      t.string :type

      t.timestamps
    end
  end
end
