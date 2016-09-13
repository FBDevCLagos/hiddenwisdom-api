directionEnum = GraphQL::EnumType.define do
  name "Query Direction"
  description "Query order by value"
  value "desc", "order in descending order by id"
  value "asc", "order in ascending order by id"
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "the query root for this schema"

  field :proverb do
    type ProverbType
    argument :id, !types.ID, "the id of the proverb to retrieve"
    resolve -> (obj, args, ctx){
      Proverb.find_by(id: args["id"])
    }
  end

  field :proverbs do
    type types[ProverbType]
    argument :limit, types.Int, default_value: 10
    argument :random, types.Boolean, default_value: false
    argument :direction, directionEnum, default_value: "desc"
    argument :offset, types.Int, default_value: 0
    argument :tags, types.String
    argument :language, types.String
    resolve -> (obj, args, ctx){
      Proverb.search(args)
    }
  end
end
