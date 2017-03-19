Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
  get '/plants/new' => 'plants#new'
  get '/plants' => 'plants#index'
  post '/plants' => 'plants#create'
  post '/friendships' => 'friendships#create'
  delete '/friendships' => 'friendships#destroy'
  match '/:username/locations/:name' => 'locations#show', :via => [:get]
  match '/:username/locations' => 'locations#index', :via => [:get]
  match '/:username/plants' => 'plants#index', :via => [:get]
  match '/:username' => 'users#show', :via => [:get]
  resources :users
  resources :locations
  resources :plants
  resources :pots
  get 'plants/update_specieses' => 'plants#update_specieses', as: 'update_specieses'
end
