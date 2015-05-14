Rails.application.routes.draw do
  root :to => redirect('/trips')

  scope(controller: :sessions) do
    get '/auth/:provider/callback', action: 'create', as: 'automatic_auth'
    get '/login', action: 'new'
    get '/logout', action: 'destroy'
  end

  resources :trips, only: [:index, :show] do
    resources :tags, only: [:create, :destroy]
  end

  resources :vehicles, only: [:index] do
    resources :trips, only: [:index], controller: 'vehicle/trips'
  end
end
