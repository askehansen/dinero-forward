class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :from_email
      t.string :from_name
      t.string :email
      t.string :subject

      t.timestamps
    end
  end
end
