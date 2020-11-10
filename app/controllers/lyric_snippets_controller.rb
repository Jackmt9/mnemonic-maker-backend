class LyricSnippetsController < ApplicationController

    def query
        initials = Artist.get_initials(params[:query])
        LyricSnippet.match_initials_to_lyrics(initials, params[:query])

    end
end
