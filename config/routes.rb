Rails.application.routes.draw do
  root to: proc { [200, {}, ['Backend is running']] }
  resources :entities do
    member do
      post :duplicate
    end
    resources :events do
      member do
        post :duplicate
        post :recurrent
        post :use_inventory
      end
    end
    resources :inventories do
      collection do
        post :use_stock, to: 'inventories#use_stock'
      end
      resources :inventory_transactions, only: [:index, :create]
    end
    resources :requests do
      member do
        post :fulfill
      end
    end
  end
  resources :events do
    member do
      post :duplicate
      post :use_inventory
    end
    resources :participants, only: [:index, :create, :update, :destroy] do
      member do
        post :duplicate
      end
    end
    resources :cars, only: [:index, :create, :update, :destroy] do
      member do
        post :clean_seats
        post :clean_donations
        post :duplicate
      end
    end
    resources :donations, only: [:index, :create, :update, :destroy] do
      member do
        post :duplicate
        post :add_to_inventory
      end
    end
    resource :donation_settings, only: [:show, :update]
    resources :comments, only: [:index, :create, :update, :destroy]
  end
  post 'auth/register', to: 'auth#register'
  post 'auth/login', to: 'auth#login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
