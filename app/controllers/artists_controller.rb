class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        render json: artists
    end

    def query
        initials = Artist.get_initials(params[:query])
        result = Artist.match_to_lyrics(initials)
        render json: result
    end
end
