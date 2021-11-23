class CreateBoletoSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_settings do |t|
      t.string :agency_number
      t.string :account_number
      t.string :bank_code
      t.references :company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
