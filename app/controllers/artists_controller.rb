class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        render json: artists
    end

    def query
        if params[:artist].to_i > 0
            artist_id = params[:artist].to_i
            #if we're already getting back the artist id, leave as is (case when we go to next result)
        else
            if Artist.find_by(name: params[:artist]) 
                artist_id = Artist.find_by(name: params[:artist]).id
            else
                artist_id = 'any'
            end
        end

        if params[:order] == "true"
            order = true
        else
            order = false
        end 
        current_song_index = params[:current_song_index].to_i
        match_info = Artist.match_to_lyrics(params[:query], current_song_index, artist_id, order)
        render json: match_info
    end
end
