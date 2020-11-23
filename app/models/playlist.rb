class Playlist < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :delete_all
  
    def self.create_favorites(user_id)
         @playlist = Playlist.create(title: "Favorites", user_id: user_id)
        if @playlist.valid?
            print('favorites playlist created')
        else
            print("Failed to create favorites playlist")
        end
    end

    def self.get_playlists_with_bookmarks(user)
        playlists = user.playlists

        playlists_with_bookmarks = []
        playlists.each do |playlist|
            flat_playlist = playlist.attributes
            flat_playlist[:bookmarks] = playlist.bookmarks
            bookmarks = self.add_song_title_to_bookmarks(flat_playlist)
            flat_playlist[:bookmarks] = bookmarks
            playlists_with_bookmarks << flat_playlist
        end 
        return playlists_with_bookmarks
    end

    def self.add_song_title_to_bookmarks(playlist)
        new_bookmarks = []
        playlist[:bookmarks].each do |bookmark| 
            song_title = Song.find(bookmark.song_id).full_title
            new_bookmark = bookmark.attributes
            new_bookmark[:full_title] = song_title
            new_bookmarks << new_bookmark
        end
        return new_bookmarks
    end
        

end
