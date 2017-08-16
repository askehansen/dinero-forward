class AddFilenameToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :filename, :string
  end
end
