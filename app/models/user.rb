class User < ApplicationRecord
  has_many :messages
  has_many :purchases, through: :messages

  validates_presence_of :organization_id, :api_key

  before_save :strip_keys

  enum plan: {
    free: 0,
    paid: 1
  }

  def permissions
    Permission.new(self)
  end

  private

  def strip_keys
    self.organization_id.strip!
    self.api_key.strip!
  end

end
