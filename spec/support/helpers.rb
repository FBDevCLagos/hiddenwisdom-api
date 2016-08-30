module Helpers
  def json
    JSON.parse(response.body)
  end

  def token_generator(user)
    user_info = { fb_id: user.fb_id, email: user.email }
    exp = Time.zone.now.to_i + 1 * 3600
    Api::V1::Authenticate.create_token(user_info, exp)
  end

  def login(user)
    token = token_generator(user)
    { "format" => :json,
      "AUTHORIZATION" => token }
  end
end
