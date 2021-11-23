class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :token
      t.integer :status, default: 0
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
