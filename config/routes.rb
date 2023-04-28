# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  authenticated :user do
    root 'projects#index', as: :authenticated_root
  end

  unauthenticated :user do
    root 'home#index', as: :unauthenticated_root
  end

  get 'project_history/index'
  patch 'projects/:id/update_status', to: 'projects#update_status', as: 'update_project_status'

  resources :projects do
    resources :comments, only: [:create, :update, :destroy]
  end
  devise_for :users
end
