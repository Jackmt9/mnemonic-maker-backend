class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        render json: artists
    end

    def query
        full_query = params[:query]
        initials = Artist.get_initials(params[:query])
        bookmark = params[:bookmark].to_i
        if Artist.find_by(name: params[:artist])
            artist_id = Artist.find_by(name: params[:artist]).id
        else
            artist_id = 'any'
        end
        if params[:order] == "true"
            order = true
        else
            order = false
        end 
        match_info = Artist.match_to_lyrics(initials, bookmark, artist_id, order, full_query)
        render json: match_info
    end
end
