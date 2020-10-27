Rails.application.routes.draw do
  resources :bookmarks
  resources :playlists

  get '/query/:query/:bookmark/artist/:artist/order/:order', to: 'artists#query'
  # Bookmark holds the place of the last search value exported, so that it can find another match for the same query.
  get '/users/stay_logged_in', to: 'users#stay_logged_in'
  post '/users/login', to: 'users#login'
  resources :users, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
