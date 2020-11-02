class PlaylistsController < ApplicationController
    before_action :authorized, only: [:create, :index]


  

    def create

        @playlist = Playlist.create(playlist_params, user: @user)

        if @playlist.valid?
            render json: {
                message: "Playlist created."
            }
        else
            render json: {
                message: "Failed to create new playlist"
            }
        end
    end

    def index
        render json: { playlists: @user.playlists }
    end

    private
  
    def playlist_params
      params.permit(:title)
    end

end