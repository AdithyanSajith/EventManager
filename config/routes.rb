Rails.application.routes.draw do
  # Devise routes for unified User model
  devise_for :users, module: 'users', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  # Devise routes for Admin (ActiveAdmin)
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root page
  root "home#index"

  # Dashboards and profile
  get "/host_dashboard", to: "hosts#dashboard", as: :host_dashboard
  get "/profile",        to: "participants#profile", as: :profile

  # Participant preference/category selection
  get   '/choose_category',  to: 'participants#choose_category', as: :choose_category
  post  '/set_preference',   to: 'participants#set_preference',  as: :set_preference
  get   '/change_category',  to: 'participants#change_category', as: :change_category
  patch '/update_interest',  to: 'participants#update_interest', as: :update_interest
  get   '/filtered_events',  to: 'events#filtered',              as: :filtered_events

  # Host: view other hosts' events (read-only)
  get '/other_events', to: 'events#other_events', as: :other_events

  # Events with nested payments, reviews, and registrations ✅
  resources :events do
    resources :payments, only: [:new, :create]
    resources :reviews,  only: [:new, :create]
    resources :registrations, only: [:new, :create]
  end

  # Venues with nested reviews
  resources :venues do
    resources :reviews, only: [:new, :create]
  end

  # General review routes
  resources :reviews, except: [:new, :create]
  get '/reviews/new', to: redirect('/')  # Prevent direct access to generic new review path

  # Other resources
  resources :registrations, only: [:create, :destroy]
  resources :categories
  resources :tickets, only: [:show]

  # -----------------------------
  # ✅ API NAMESPACE FOR FRONTEND
  # -----------------------------
  namespace :api do
    namespace :v1 do
      resources :events, only: [] do
        resources :reviews, only: [:index, :create]
        get 'registration_status', to: 'registrations#status'
        post 'payment', to: 'payments#create'
      end

      resources :tickets, only: [:show]
      resource :profile, only: [:show, :update]
    end
  end
end
