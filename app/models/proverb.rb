class Proverb < ActiveRecord::Base
  belongs_to :user
  belongs_to :root, class_name: "Proverb", foreign_key: "root_id"
  has_many :taggings
  has_many :tags, through: :taggings
  validates :language, :body, :user, presence: true

  def translations
    Proverb.where("root_id = #{id} OR id = #{root_id}").where.not(id: id)
  end

  #Getter and Setter for all_tags vertial attribute
  def all_tags=(proverb_tags)
    self.tags = proverb_tags.map do |proverb_tag|
      Tag.where(name: proverb_tag.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end
end
