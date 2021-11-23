class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.string :token
      t.text :name
      t.integer :status, default: 5
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
