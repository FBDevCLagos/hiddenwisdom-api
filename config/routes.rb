Rails.application.routes.draw do
  namespace :api, default: { format: :json } do
    namespace :v1 do
      scope "/:locale" do
        resources :proverbs, except: [:new, :edit] do
          get "approve", on: :member
        end
      end
      post "/auth/login", to: "auth#login"
      get "/auth/logout", to: "auth#logout"
    end
  end
end
