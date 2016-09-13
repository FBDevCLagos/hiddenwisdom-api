TagType = GraphQL::ObjectType.define do
  name "Tag"
  description "A tag"

  field :id, types.ID, "Tag Id"
  field :name, types.String, "Name of the tag"
  field :created_at, types.String, "Data tag was created"
  field :updated_at, types.String, "Data tag was last updated"
  field :proverbs do
    type !types[!ProverbType]
    resolve -> (obj, args, ctx){
      obj.proverbs
    }
  end
end
