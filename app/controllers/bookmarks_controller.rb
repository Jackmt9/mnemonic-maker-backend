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
    
    def destroy
        Bookmark.find(params[:id]).destroy()
    end
    
    private
  
    def bookmark_params
      params.require(:bookmark).permit(:playlist_id, :song_id, :input_phrase, :matching_phrase, :youtube_id)
    end

end
