class SongsController < ApplicationController
    # def index
    #     songs = Song.all 
    #     render json: songs 
    # end

    def show 
        song = Song.find(params[:id])
        render json: song
    end
end
