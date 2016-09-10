class ProverbSerializer < ActiveModel::Serializer
  attributes :id, :body, :language, :status, :root_id, :created_at, :translations

  def translations
    object.translations
  end
end
