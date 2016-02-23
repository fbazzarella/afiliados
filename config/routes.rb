require 'sidekiq/web'

NewApp::Application.routes.draw do
  root to: 'campaigns#index'

  devise_for :users

  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :campaigns, only: [:index, :create, :destroy] do
    get 'chase', as: :chase
  end

  resources :lists, only: [:index, :create, :destroy] do
    get 'download', as: :download
  end

  resources :newsletters, only: [:index, :create, :destroy]

  resources :imports, only: [] do
    get 'progress', as: :progress, on: :collection
  end

  resources :shots, only: [] do
    post 'event-postback', on: :collection

    member do
      get 'opened'
      get 'unsubscribed'
    end
  end

  resources :links, only: [:show]

  resources :relays, only: [:index, :create]
end
