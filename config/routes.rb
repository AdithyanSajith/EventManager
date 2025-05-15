Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  devise_for :hosts

  # Skip default registrations routes for participants
  devise_for :participants, controllers: {
    registrations: 'participants/registrations'
  }, skip: [:registrations]

  # Manually define registrations routes for participants
  devise_scope :participant do
    get    'participants/sign_up', to: 'participants/registrations#new',    as: :new_participant_registration
    post   'participants',         to: 'participants/registrations#create', as: :participant_registration
    get    'participants/edit',    to: 'participants/registrations#edit',   as: :edit_participant_registration
    patch  'participants',         to: 'participants/registrations#update'
    put    'participants',         to: 'participants/registrations#update'
    delete 'participants',         to: 'participants/registrations#destroy'
    get    'participants/cancel',  to: 'participants/registrations#cancel', as: :cancel_participant_registration
  end

  # Your other routes...
  get '/choose_category', to: 'participants#choose_category'
  post '/set_preference', to: 'participants#set_preference'
  get '/filtered_events', to: 'events#filtered', as: 'filtered_events'
  get '/change_category', to: 'participants#change_category', as: :change_category
  patch '/update_interest', to: 'participants#update_interest', as: :update_interest

  resources :events do
    resources :payments, only: [:new, :create]
  end

  resources :venues
  resources :categories
  resources :tickets, only: [:show]
  resources :reviews
end
