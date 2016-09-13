ProverbSchema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
  max_depth 8
end

ProverbSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.messages.to_json
end
