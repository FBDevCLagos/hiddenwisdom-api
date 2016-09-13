CreateProverb = GraphQL::Relay::Mutation.define do
  name "Create Proverb"
  description "Create proverbs"

  input_field :language, !types.String
  input_field :body, !types.String
  input_field :root_id, types.ID
  input_field :tags, types.String

  return_field :proverb, ProverbType

  resolve -> (inputs, context){
    user = context[:current_user]
    raise GraphQL::ExecutionError, "you need to be authorized to completed this action" unless user

    tags = inputs["tags"] ? inputs.split(",") : []
    {proverb: Proverb.create(body: inputs["body"], language: inputs["language"], root_id: inputs["root_id"], all_tags: tags, user: user)}
  }
end
