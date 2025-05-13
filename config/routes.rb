Rails.application.routes.draw do
  root "home#index"

  devise_for :hosts
  devise_for :participants

  # Routes for category selection and preference setting
  get '/choose_category', to: 'participants#choose_category'
  post '/set_preference', to: 'participants#set_preference'
  get '/filtered_events', to: 'events#filtered', as: 'filtered_events'
  get '/change_category', to: 'participants#change_category', as: :change_category
  patch '/update_interest', to: 'participants#update_interest', as: :update_interest

  # Event and payment routes
  resources :events do
    resources :payments, only: [:new, :create]
  end

  # Other resource routes
  resources :venues
  resources :categories
  resources :registrations, only: [:create, :destroy]
  resources :tickets, only: [:show]
  resources :reviews
end
