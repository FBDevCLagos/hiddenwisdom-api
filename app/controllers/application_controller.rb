class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  rescue_from ActiveRecord::RecordNotFound do
    render json: { Error: "Resource not found" }, status: 404
  end

  attr_reader :current_user, :token

  def no_route_found
    found = { Error: "The end point you requested does not exist.",
              Debug: "Please check the documentation for existing end points" }
    render json: found, status: 404
  end

  def authenticate
    @token = request.headers["HTTP_AUTHORIZATION"]
    if token_has_expired(token)
      render json: { Error: "Token has expired, please login again" }, status: 401
    else
      status, payload = Api::V1::Authenticate.decode_token(token)
      set_payload(status, payload)
    end
  end

  def activate(user)
    unless user
      render json: { Error: "You must login first" }, status: 401
    end
  end

  private

  def token_has_expired(token)
    user_expired_tokens = ExpiredToken.where(token: token)
    user_expired_tokens.present?
  end

  def set_payload(status, payload)
    if status
      user = payload
      @current_user = User.find_by(fb_id: user["fb_id"]) ||
                      User.find_by(kit_id: user["kit_id"])
      activate(@current_user)
    else
      render json: payload, status: 401
    end
  end
end
