class User < ActiveRecord::Base
  validates :username, :email, :fb_id, :first_name, :last_name, presence: true
  validates :email, uniqueness: true

  enum user_type: {regular: 0, moderator: 1, admin: 2}


  def self.find_or_create_user(auth_params)
     find_or_create_by(fb_id: auth_params[:id]) do |user|
      user.username =  auth_params[:username]
      user.first_name =  auth_params[:first_name]
      user.last_name =  auth_params[:last_name]
      user.email =  auth_params[:email]
    end
  end
end
