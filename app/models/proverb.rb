class Proverb < ActiveRecord::Base
  belongs_to :user

  validates :language, :body, :user_id, presence: true
end
