NewApp::Application.routes.draw do
  root to: 'campaigns#index'

  devise_for :users

  resources :campaigns, only: :index
end
