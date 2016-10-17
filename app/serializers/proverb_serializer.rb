class ProverbSerializer < ActiveModel::Serializer
  attributes :id, :body, :status, :tags, :created_at, :translations

  # has_many :taggings
  # has_many :tags

  def translations
    object.translations
  end

  def tags
    object.tags.map(&:name)
  end
end
