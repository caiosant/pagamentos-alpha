class CreateRejectedCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :rejected_companies do |t|
      t.references :company, null: false, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
