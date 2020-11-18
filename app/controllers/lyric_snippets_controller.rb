class LyricSnippetsController < ApplicationController

    def query
        initials = Artist.get_initials(params[:query])
        matching_result = LyricSnippet.match_initials_to_lyrics(params[:query], params[:current_snippet_index].to_i, params[:order])
        render json: matching_result
    end
end
