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
    tag_names = proverb_tags.collect{|tag_name| tag_name.strip.downcase}.uniq
    self.tags = tag_names.map do |proverb_tag|
      Tag.where(name: proverb_tag).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end

  def self.search(params)
    query = self.eager_load(:user)
    if params["tags"]
      query = query.joins(:tags).where(tags: {name: params["tags"].split(",")})
    end

    if params["language"]
      query = query.where(language: params["language"].split(","))
    end

    ord = params["random"] ? "RANDOM()" : "id #{params["direction"]}"

     query.limit(params["limit"]).order(ord).offset("#{params["offset"]}")
  end
end
