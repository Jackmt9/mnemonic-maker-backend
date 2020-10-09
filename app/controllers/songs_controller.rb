class SongsController < ApplicationController
    def index
        songs = Song.all 
        render json: songs 
    end
end
