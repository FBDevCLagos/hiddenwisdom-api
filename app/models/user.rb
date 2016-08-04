class User < ActiveRecord::Base
  validates :username, :email, :fb_id, :first_name, :last_name, presence: true
  validates :email, uniqueness: true

  enum user_type: {regular: 0, moderator: 1, admin: 2}
end
