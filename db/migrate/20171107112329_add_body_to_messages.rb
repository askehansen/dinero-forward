class AddBodyToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :body, :text
  end
end
