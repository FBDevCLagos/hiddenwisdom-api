Rails.application.routes.draw do
  namespace :api, default: { format: :json } do
    namespace :v1 do
      resources :proverbs, except: [:new, :edit]
      post "/auth/login", to: "auth#login"
      get "/auth/logout", to: "auth#logout"
    end

    namespace :v2 do
      post "/queries", to:"graph#process_query"
    end
  end
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api/v2/queries"
end
