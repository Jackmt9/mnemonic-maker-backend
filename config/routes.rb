Rails.application.routes.draw do
  resources :songs
  resources :artists
  get '/query/:query', to: 'artists#query'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
