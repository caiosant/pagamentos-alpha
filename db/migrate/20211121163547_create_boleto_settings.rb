class CreateBoletoSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_settings do |t|
      t.integer :agency_number
      t.integer :account_number
      t.integer :bank_code
      t.references :company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
