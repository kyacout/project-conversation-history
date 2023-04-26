# frozen_string_literal: true

Rails.application.routes.draw do
  get 'project_history/index'
  resources :projects do
    resources :comments
    resources :project_histories
  end
  devise_for :users

  # Defines the root path route ("/")
  root to: 'home#index'
end
