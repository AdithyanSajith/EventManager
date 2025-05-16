Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root
  root "home#index"

  # Devise for unified User model (with roles: host, participant)
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # User role-specific category/interest actions
  get  '/choose_category',  to: 'participants#choose_category'
  post '/set_preference',   to: 'participants#set_preference'
  get  '/filtered_events',  to: 'events#filtered',            as: :filtered_events
  get  '/change_category',  to: 'participants#change_category', as: :change_category
  patch '/update_interest', to: 'participants#update_interest', as: :update_interest

  # Events + nested payments
  resources :events do
    resources :payments, only: [:new, :create]
  end

  # Event registrations
  resources :registrations, only: [:create, :destroy]

  # Additional resources
  resources :venues
  resources :categories
  resources :tickets, only: [:show]
  resources :reviews
end
