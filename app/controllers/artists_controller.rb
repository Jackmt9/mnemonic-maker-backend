class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        render json: artists
    end

    def query
        initials = Artist.get_initials(params[:query])
        bookmark = params[:bookmark].to_i
        match_info = Artist.match_to_lyrics(initials, bookmark)
        # ^^ we need all song info, along with highlighted lyrics
        render json: match_info
    end
end
