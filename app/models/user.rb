class User < ActiveRecord::Base
  has_many :proverbs

  enum user_type: { regular: 0, moderator: 1, admin: 2 }

  def self.find_or_create_user(user_info)
    create_account_kit_user(user_info) || create_graph_user(user_info)
  end

  private

  def self.create_account_kit_user(user_info)
    user_info = HashWithIndifferentAccess.new(user_info)
    return false unless account_kit_user?(user_info)

    find_or_create_by(kit_id: user_info["id"]) do |user|
      user.phone_number = user_info["phone"]["number"] if user_info["phone"]
      user.email = user_info["email"]["address"] if user_info["email"]
    end
  end

  def self.create_graph_user(auth_params)
    return false unless graph_user?(auth_params)

    find_or_create_by(fb_id: auth_params["id"]) do |user|
      user.first_name = auth_params["first_name"]
      user.last_name = auth_params["last_name"]
      user.email = auth_params["email"]
    end
  end

  def self.account_kit_user?(user_info)
    user_info["phone"] || (user_info["email"] && user_info["email"]["address"])
  end

  def self.graph_user?(auth_params)
    auth_params["first_name"] && auth_params["last_name"]
  end
end
