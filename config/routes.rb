Rails.application.routes.draw do
  # Admin dashboard and authentication
  get "/host_dashboard", to: "hosts#dashboard", as: :host_dashboard
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "home#index"

  # Devise routes for users with custom controllers
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
  }

  # Participant category preference routes
  get  '/choose_category',  to: 'participants#choose_category'
  post '/set_preference',   to: 'participants#set_preference'
  get  '/filtered_events',  to: 'events#filtered', as: :filtered_events
  get  '/change_category',  to: 'participants#change_category', as: :change_category
  patch '/update_interest', to: 'participants#update_interest', as: :update_interest

  # Event-related routes with nested payments
  resources :events do
    resources :payments, only: [:new, :create]
  end

  # Event registrations
  resources :registrations, only: [:create, :destroy]

  # Basic resources
  resources :venues
  resources :categories
  resources :tickets, only: [:show]
  resources :reviews
end
