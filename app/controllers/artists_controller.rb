class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        render json: artists
    end
    def query
        result = Artist.match_to_lyrics(params[:query])
        render json: result
    end
end
