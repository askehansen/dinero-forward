class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :message, foreign_key: true
      t.string :file_key
      t.integer :status

      t.timestamps
    end
  end
end
