Rails.application.routes.draw do
  root 'pages#home'

  get '/download/trips(.:format)', to: 'trips#download', as: 'download_trips'

  get '/login', to: 'pages#login'
  scope(controller: :sessions) do
    get '/login', action: 'create'
    get '/logout', action: 'destroy'
  end

  resources :trips, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
end
