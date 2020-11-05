class BookmarksController < ApplicationController
    before_action :authorized, only: [:create, :index]

    def create
        @bookmark = Bookmark.create(bookmark_params)

        if @bookmark.valid?
            render json: { message: "Bookmark created." }
        else
            render json: { message: "Failed to create new bookmark" }
        end 
    end

    def index
        render json: { bookmarks: @user.bookmarks }
    end

    def tune_to_tube
        # byebug
        youtube_id = Song.get_youtube_id(params[:full_title])
        render json: {youtube_id: youtube_id}
    end

    private
  
    def bookmark_params
      params.permit(:playlist_id, :song_id, :input_phrase, :matching_phrase)
    end

end
