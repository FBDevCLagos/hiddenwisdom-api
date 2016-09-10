class ProverbSerializer < ActiveModel::Serializer
  attributes :id, :body, :language, :status, :root_id, :tags, :created_at, :translations

  # has_many :taggings
  has_many :tags

  def translations
    object.translations
  end
end
