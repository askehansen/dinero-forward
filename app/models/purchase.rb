class Purchase < ApplicationRecord
  belongs_to :message
  has_one :user, through: :message
  # belongs_to :user, through: :message

  enum status: {
    unprocessed: 0,
    processed: 1
  }

  def file
    Storage.new.open_file(file_key)
  end

end
