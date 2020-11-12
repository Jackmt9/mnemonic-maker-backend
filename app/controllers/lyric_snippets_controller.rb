class LyricSnippetsController < ApplicationController

    def query
        initials = Artist.get_initials(params[:query])
        matching_result = LyricSnippet.match_initials_to_lyrics(initials, params[:query])
        render json: matching_result
    end
end
