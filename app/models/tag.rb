class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :proverbs, through: :taggings
end
