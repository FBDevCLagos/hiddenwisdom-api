AuthenticateUser = GraphQL::Relay::Mutation.define do
  name "Authenticate user"
  description "Authenticates the user"

  input_field :access_token, !types.String
  return_field :user, !UserType
  return_field :token, !types.String

  resolve -> (inputs, ctx){
    params = {
      fields: FIELDS,
      access_token: inputs["access_token"]
    }

    http_client = Api::V1::Http.new(FB_URL)
    response, status = http_client.get_request(params)

    if status != "200"
      raise GraphQL::ExecutionError, "Could not validate user"
    end
    user = User.find_or_create_user(response)
    token = Authenticate.create_token(fb_id: user.fb_id, email: user.email)
    { token: token, user: user }
  }
end
