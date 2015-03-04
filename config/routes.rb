Rails.application.routes.draw do
  root 'pages#home'

  get '/login', to: 'pages#login'
  get '/auth/:provider/callback', to: 'pages#create_session', as: 'automatic_auth'

  get '/download/trips(.:format)', to: 'trips#download', as: 'download_trips'

  scope(controller: :sessions) do
    get '/login', action: 'create'
    get '/logout', action: 'destroy'
  end

  resources :trips, only: [:index, :show]
  resources :vehicles, only: [:index]
end
