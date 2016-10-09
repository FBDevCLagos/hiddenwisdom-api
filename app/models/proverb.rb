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

  def self.paginate(params)
    params[:direction] = "RANDOM()" if params[:direction] == 'random'
    query = self.includes(:tags)
    query = query.filter_language(params) if params[:language]
    query = query.filter_tag(params) if params[:tag]
    query.filter_order(params).filter_limit(params).filter_offset(params)
  end

  scope :filter_language, ->(args) { where("lower(language) LIKE ?", "%#{args[:language]}%")}
  scope :filter_tag, -> (args) { where(tags: {name: args[:tag]})}
  scope :filter_order, -> (args) { order("proverbs.#{args[:order] || 'id'} #{args[:direction] || 'desc'} ")}
  scope :filter_limit, -> (args) { limit(args[:limit] || 20)}
  scope :filter_offset, -> (args) { offset(args[:offset] || 0)}
end
