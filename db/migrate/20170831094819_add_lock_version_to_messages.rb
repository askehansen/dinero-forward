class AddLockVersionToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :lock_version, :integer
  end
end
