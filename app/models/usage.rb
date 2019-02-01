class Usage < ApplicationRecord
  belongs_to :user

  def self.generate!(user, date)
    usage = Usage.find_or_initialize_by(user: user, used_on: date)
    messages = Message.where(user: user)
    usage.used = Purchase.processed.where("purchases.created_at > ?", date).where("purchases.created_at < ?", date.next_day).joins(:message).merge(messages).count
    usage.save!
  end

end
