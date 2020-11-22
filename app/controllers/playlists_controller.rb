class PlaylistsController < ApplicationController
    before_action :authorized, only: [:create, :index, :show, :update, :destroy]


    def create
        playlist = Playlist.create(title: playlist_params["title"], description: playlist_params["description"], user: @user)
        if playlist.valid?
            render json: playlist
        else
            render json: {
                message: "Failed to create new playlist."
            }
        end
    end

    def index
        render json: @user.playlists.all
        
    end

    def update
        playlist = Playlist.find(params[:playlist_id])
        playlist.update(title: params[:playlist_params]["title"], description: params[:playlist_params]["description"])
        render json: playlist
    end

    def destroy
        playlist = Playlist.find(params[:id]).destroy()
        render json: playlist

    end
    # def show
    #     begin 
    #         @playlist = @user.playlists.find(params[:id])
    #             render json: { 
    #                 playlist: {
    #                     id: @playlist.id,
    #                     title: @playlist.title,
    #                     bookmarks: @playlist.bookmarks
    #                 }
    #             }
    #     rescue
    #         render json: {
    #             message: "Unable to find playlist."
    #         }
    #     end
    # end

    private
  
    def playlist_params
      params.permit(:title, :description)
    end

end