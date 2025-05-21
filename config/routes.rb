Rails.application.routes.draw do
  resources :entities do
    member do
      post :duplicate
    end
    resources :events
  end
  resources :events do
    member do
      post :duplicate
    end
    resources :participants, only: [:index, :create, :update, :destroy]
    resources :cars, only: [:index, :create, :update, :destroy] do
      member do
        post :clean_seats
        post :clean_donations
      end
    end
    resources :donations, only: [:index, :create, :update, :destroy] do
      member do
        post :duplicate
      end
    end
    resource :donation_settings, only: [:show, :update]
  end
  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
