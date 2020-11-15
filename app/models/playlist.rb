class Playlist < ApplicationRecord
  belongs_to :user
  has_many :bookmarks
  
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
            playlists_with_bookmarks << flat_playlist
        end
        return playlists_with_bookmarks
    end

end
