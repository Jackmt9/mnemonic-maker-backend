class PlaylistsController < ApplicationController
    before_action :authorized, only: [:create, :index, :show]


  

    def create
        @playlist = Playlist.create(playlist_params, user: @user)

        if @playlist.valid?
            render json: {
                message: "Playlist created."
            }
        else
            render json: {
                message: "Failed to create new playlist."
            }
        end
    end

    def index
        render json: @user.playlists.all 
    end

    def show
        @playlist = @user.playlists.find(params[:id])

        if @playlist.valid?
            render json: {
                playlist: @playlist
            }
        else
            render json: {
                message: "Unable to find playlist."
            }
        end
    end

    private
  
    def playlist_params
      params.permit(:title)
    end

end