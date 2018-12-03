class AddRawHtmlToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :raw_html, :text
  end
end
