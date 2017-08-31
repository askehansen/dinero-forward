class AddStatusToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :status, :integer
  end
end
