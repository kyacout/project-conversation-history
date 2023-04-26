# frozen_string_literal: true

Rails.application.routes.draw do
  resources :projects
  devise_for :users

  # Defines the root path route ("/")
  root to: 'home#index'
end
