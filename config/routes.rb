require 'sidekiq/web'

NewApp::Application.routes.draw do
  root to: 'campaigns#index'

  devise_for :users

  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :campaigns, only: [:index, :create]

  resources :lists, only: [] do
    collection do
      post 'upload',          as: :upload
      get  'import-progress', as: :import_progress
    end
  end

  resources :shots, only: [] do
    post 'event-postback', on: :collection
  end
end
