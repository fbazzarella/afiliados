require 'sidekiq/web'

NewApp::Application.routes.draw do
  root to: 'campaigns#index'

  devise_for :users

  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :campaigns, only: :index

  resources :shots, only: [] do
    post 'event-postback', on: :collection
  end
end
