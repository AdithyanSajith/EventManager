Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users, module: 'users', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  # Devise routes for admin users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root "home#index"

  # Dashboard and profile routes
  get "/host_dashboard", to: "hosts#dashboard", as: :host_dashboard
  get "/profile", to: "participants#profile", as: :profile

  
  get  '/choose_category',  to: 'participants#choose_category'
  post '/set_preference',   to: 'participants#set_preference'
  get  '/filtered_events',  to: 'events#filtered', as: :filtered_events
  get  '/change_category',  to: 'participants#change_category', as: :change_category
  patch '/update_interest', to: 'participants#update_interest', as: :update_interest

  # Nested reviews under events (new/create only)
  resources :events do
    resources :payments, only: [:new, :create]
    resources :reviews, only: [:new, :create]
  end

  # Nested reviews under venues (new/create only)
  resources :venues do
    resources :reviews, only: [:new, :create]
  end

  # General reviews routes for index/show/edit/update/destroy
  resources :reviews, except: [:new, :create]

  # Safety redirect to prevent /reviews/new from being misrouted
  get '/reviews/new', to: redirect('/')

  # Other resources
  resources :registrations, only: [:create, :destroy]
  resources :categories
  resources :tickets, only: [:show]
end
