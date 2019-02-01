class CreateUsages < ActiveRecord::Migration[5.2]
  def change
    create_table :usages do |t|
      t.integer :used
      t.date :used_on
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
