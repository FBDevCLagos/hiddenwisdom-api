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
    params = sanitize_search_params(params)
    query = self.eager_load(:tags)
    query = query.filter_language(params) if params[:language]
    query = query.filter_tag(params) if params[:tag]
    query.filter_order(params).filter_limit(params).filter_offset(params)
  end

  def self.sanitize_search_params(params)
    params[:limit] = nil unless params[:limit].to_i > 0
    params[:offset] = nil unless params[:offset].to_i > 0
    params[:tag] = "%#{params[:tag].downcase}%" if params[:tag]
    params[:language] = "%#{params[:language].downcase}%" if params[:language]
    sanitize_order_by(params)
  end

  def self.sanitize_order_by(params)
    order_by = (self.column_names.include? params[:order]) ? params[:order] : 'id'
    params[:order] = "proverbs.#{order_by}"
    sanitize_direction(params)
  end

  def self.sanitize_direction(params)
    params.tap do |args|
      if args[:direction] == 'random'
        args[:direction] = 'RANDOM()'
        args[:order] = ''
      elsif !%w(desc asc).include? args[:direction]
        args[:direction] = 'desc'
      end
    end
  end

  scope :filter_language, ->(args) { where("language LIKE ?", args[:language])}
  scope :filter_tag, -> (args) { where('tags.name LIKE ?', args[:tag])}
  scope :filter_order, -> (args) { order("#{args[:order]} #{args[:direction]}") }
  scope :filter_limit, -> (args) { limit(args[:limit] || 20)}
  scope :filter_offset, -> (args) { offset(args[:offset] || 0)}
end
