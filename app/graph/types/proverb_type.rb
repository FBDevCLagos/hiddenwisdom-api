ProverbType = GraphQL::ObjectType.define do
  name "Proverb"
  description "A proverb"

  field :id, types.ID, "Proverb Id"
  field :body, types.String, "body of the proverb"
  field :language, types.String, "language of the proverb"
  field :status, types.String, "status of proverb"
  field :created_at, types.String, "date proverb was created"
  field :updated_at, types.String, "data proverb was last updated"
  field :user do
    type UserType
    resolve -> (obj, args, ctx){
      obj.user
    }
  end
  field :translations do
    type types[ProverbType]
    resolve -> (obj, args, ctx){
      obj.translations
    }
  end
  field :tags do
    type types[TagType]
    resolve -> (obj, args, ctx){
      obj.tags
    }
  end
end
