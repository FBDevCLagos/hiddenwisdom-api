class Tagging < ActiveRecord::Base
  belongs_to :proverb
  belongs_to :tag
end
