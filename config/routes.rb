Rails.application.routes.draw do
  namespace :api, format: { default: :json } do
    namespace :v1 do
      resources :users, only: [:create]

      # Auth
      resources :sessions, only: [:index, :create, :destroy]
    end
  end
end
