class ProverbSerializer < ActiveModel::Serializer
  attributes :id, :body, :language, :status, :root_id, :created_at, :updated_at, :user_id
end
