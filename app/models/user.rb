class User < ActiveRecord::Base
  has_many :proverbs

  enum user_type: { regular: 0, moderator: 1, admin: 2 }

  def self.find_or_create_user(user_info)
    user_info = HashWithIndifferentAccess.new(user_info)
    
    find_or_create_by(kit_id: user_info["id"]) do |user|
      user.phone_number = user_info["phone"]["number"] if user_info["phone"]
      user.email = user_info["email"]["address"] if user_info["email"]
    end
  end
end
