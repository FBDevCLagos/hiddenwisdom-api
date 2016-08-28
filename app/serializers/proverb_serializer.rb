class ProverbSerializer < ActiveModel::Serializer
  attributes :id, :body, :language, :status, :created_at, :updated_at
end
