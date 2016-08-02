Rails.application.routes.draw do
  namespace :api, path: "/", default: { format: :json } do
    scope module: :v1 do
      
    end
  end
end
