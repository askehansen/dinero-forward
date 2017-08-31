class Message < ApplicationRecord
  belongs_to :user
  has_many :purchases

  enum status: {
    unprocessed: 0,
    processed: 1
  }
end
