MutationType = GraphQL::ObjectType.define do
  name "Root mutation"
  description "Entry point for resources changes"

  field :create_proverb, field: CreateProverb.field
  # field :delete_proverb, field: DeleteProverb.field
  # field :update_proverb, field: UpdateProverb.field
  field :authenticate_user, field: AuthenticateUser.field
end
