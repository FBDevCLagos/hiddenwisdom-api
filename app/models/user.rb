class User < ActiveRecord::Base
  validates :username, :email, :fb_id, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end
