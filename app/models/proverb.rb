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

  scope :search, lambda { |params = {}|
    tag = params[:tag].downcase if params[:tag]
    language = params[:language].downcase if params[:language]
    ord = params["random"] ? "RANDOM()" : "id #{params[:direction]}"
    set_order = ord == "id " ? "proverbs.id desc" : ord
    Proverb.select("proverbs.*, #{ord}").joins(:tags).where(
      "tags.name LIKE ? and lower(language) LIKE ?",
      "%#{tag}%",
      "%#{language}%"
    ).order(set_order).uniq
  }

  def self.paginate(params)
    limit = params[:limit] ? params[:limit] : 20
    page = params[:page] ? params[:page] : 0
    # offset = limit.to_i * (page.to_i - 1)
    offset = page == 0 ? 0 : (page.to_i - 1) * limit.to_i
    search(params).limit(limit).offset(offset)
  end
end
