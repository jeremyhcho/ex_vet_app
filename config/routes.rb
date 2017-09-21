Rails.application.routes.draw do
  namespace :api, format: { default: :json } do
    namespace :v1 do
      resources :users, only: [:create, :update, :show] do
        collection do
          post 'recover', to: 'users#recover'
          get 'validate_reset', to: 'users#validate_reset'
        end
      end

      # Auth
      post :login, to: 'sessions#login'
      delete :logout, to: 'sessions#logout'
    end
  end
end
