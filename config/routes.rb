Rails.application.routes.draw do
  namespace :api, format: { default: :json } do
    namespace :v1 do
      resources :users, only: [:create]

      # Auth
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end
  end
end
