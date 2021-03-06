class User < ApplicationRecord
  has_many :messages
  has_many :purchases, through: :messages
  has_many :usages

  validates_presence_of :organization_id, :api_key
  before_validation :strip_keys

  enum plan: {
    free: 0,
    pro: 1
  }

  def can
    Permission.new(self)
  end

  private

  def strip_keys
    self.organization_id&.strip!
    self.api_key&.strip!
  end

end
