Rails.application.routes.draw do
  resources :bookmarks
  resources :playlists
  resources :users
  # resources :songs
  # resources :artists
  get '/query/:query/:bookmark/artist/:artist/order/:order', to: 'artists#query'
  # Bookmark holds the place of the last search value exported, so that it can find another match for the same query.
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
