Rails.application.routes.draw do
  # Devise authentication with custom controllers
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  # OTP Verification
  resource :otp_verification, only: [:new, :create] do
    post :resend, on: :collection
  end
  
  # Root route
  root "home#index"
  
  # Properties
  resources :properties do
    resources :reviews, only: [:create, :destroy]
    resources :messages, only: [:new, :create]
    resources :inquiries, only: [:index, :create]
    member do
      post :add_to_favorites
    end
  end
  
  # Inquiries (for updates and show)
  resources :inquiries, only: [:show, :update]
  
  # Dashboard
  get "dashboard", to: "dashboards#show"
  
  # Favorites
  resources :favorites, only: [:index, :create, :destroy]
  
  # Messages
  resources :messages, only: [:index, :show]
  
  # Search
  get "search", to: "searches#index"
  
  # Comparison
  resources :comparisons, only: [:index, :create, :destroy] do
    collection do
      delete :clear
    end
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
