class CreateCreditCardSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_settings do |t|
      t.string :company_code
      t.references :company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
