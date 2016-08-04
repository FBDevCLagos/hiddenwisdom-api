Rails.application.routes.draw do
  namespace :api, default: { format: :json } do
    namespace :v1 do
      post "/auth/login", to: "auth#login"
      get "/auth/logout", to: "auth#logout"
    end
  end
end
