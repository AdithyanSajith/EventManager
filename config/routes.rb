Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, module: 'users', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "home#index"

  get "/host_dashboard", to: "hosts#dashboard", as: :host_dashboard
  get "/profile",        to: "participants#profile", as: :profile

  get   '/choose_category',  to: 'participants#choose_category', as: :choose_category
  post  '/set_preference',   to: 'participants#set_preference',  as: :set_preference
  get   '/change_category',  to: 'participants#change_category', as: :change_category
  patch '/update_interest',  to: 'participants#update_interest', as: :update_interest
  get   '/filtered_events',  to: 'events#filtered',              as: :filtered_events

  get '/other_events', to: 'events#other_events', as: :other_events
  get '/past_events', to: 'events#past_events', as: :past_events
  get '/other_hosts_events', to: 'events#other_hosts_events', as: :other_hosts_events
  
  # Toastr demo routes for testing notifications
  get '/toastr_demo', to: 'toastr_demo#index', as: :toastr_demo
  get '/toastr_demo/trigger/:type', to: 'toastr_demo#trigger', as: :toastr_demo_trigger
  get '/toastr_demo/simulate/:action_type', to: 'toastr_demo#simulate_action', as: :toastr_demo_simulate

  resources :events do
    resources :payments, only: [:new, :create]
    resources :reviews,  only: [:new, :create]
    resources :registrations, only: [:index, :new, :create]
  end

  resources :venues do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, except: [:new, :create]
  get '/reviews/new', to: redirect('/')

  resources :registrations
  resources :categories
  resources :tickets
  resources :participants
  resources :payments
  resources :users, only: [:show] # <-- Added for UsersController#show spec

  namespace :api do
    namespace :v1 do
      get 'top_events', to: 'events#top_rated'

      resources :events, only: [:index, :show, :create, :update, :destroy] do
        resources :reviews, only: [:index, :create], module: :events
        resources :registrations, only: [:index, :create], module: :events

        get 'registration_status', to: 'events/registrations#status'
        post 'payment', to: 'events/payments#create'
      end

      resources :tickets, only: [:index, :show]
      resource :profile, only: [:show, :update]

      get 'user_registered_events', to: 'events/registrations#user_registered_events'
    end
  end

  get 'events/:id/download_ics', to: 'events#download_ics', as: :download_event_ics
  get '/hosted_events', to: 'events#hosted', as: :hosted_events
  get '/host_reviews', to: 'reviews#host_reviews', as: :host_reviews
  post '/host_reviews/create_venue_review', to: 'reviews#create_venue_review', as: :create_venue_review
end