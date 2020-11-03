Rails.application.routes.draw do
  resources :bookmarks, only: [:create]
  resources :playlists

  get '/query/:query/:current_song_index/artist/:artist/order/:order', to: 'artists#query'
  # current_song_index holds the place of the last search value exported, so that it can find another match for the same query.
  get '/stay_logged_in', to: 'users#stay_logged_in'
  post '/login', to: 'users#login'
  # post '/stay_logged_in', to: 'users#stay_logged_in'
  resources :users, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end