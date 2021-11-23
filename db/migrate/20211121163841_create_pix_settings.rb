class CreatePixSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :pix_settings do |t|
      t.string :pix_key
      t.string :bank_code
      t.references :company, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
