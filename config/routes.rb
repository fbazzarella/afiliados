require 'sidekiq/web'

NewApp::Application.routes.draw do
  root to: 'campaigns#index'

  devise_for :users

  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :campaigns,   only: [:index, :create] do
    get 'chase', as: :chase
  end

  resources :lists,       only: [:index, :create, :destroy]
  resources :newsletters, only: [:index, :create, :destroy]

  resources :imports, only: [] do
    get 'progress', as: :progress, on: :collection
  end

  resources :shots, only: [] do
    post 'event-postback', on: :collection
  end
end
