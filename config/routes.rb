# frozen_string_literal: true

Rails.application.routes.draw do
  get 'project_history/index'
  put 'projects/:id/update_status', to: 'projects#update_status', as: 'update_status'

  resources :projects do
    resources :comments
    resources :project_histories
  end
  devise_for :users

  # Defines the root path route ("/")
  root to: 'home#index'
end
