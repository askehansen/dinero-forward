class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :organization_id
      t.string :api_key

      t.timestamps null: false
    end
  end
end
