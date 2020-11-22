Rails.application.routes.draw do
  resources :bookmarks, only: [:create, :destroy]
  resources :playlists, only: [:create, :index, :update, :destroy]
  resources :songs, only: [:show]

  resources :users, only: [:create]

  get '/query/:query/:current_song_index/artist/:artist/order/:order', to: 'artists#query'
  # current_song_index holds the place of the last search value exported, so that it can find another match for the same query.
  get '/stay_logged_in', to: 'users#stay_logged_in'
  # post '/stay_logged_in', to: 'users#stay_logged_in'
  post '/login', to: 'users#login'
    #retrieves youtube url based on song id
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end