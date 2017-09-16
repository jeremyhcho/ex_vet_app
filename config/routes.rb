Rails.application.routes.draw do
  namespace :api, format: { default: :json } do
    namespace :v1 do
      resources :users, only: [:create, :show]

      # Auth
      post :login, to: 'sessions#login'
      delete :logout, to: 'sessions#logout'
    end
  end
end
