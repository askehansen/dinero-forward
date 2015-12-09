class User < ActiveRecord::Base
  validates_presence_of :organization_id, :api_key
end
