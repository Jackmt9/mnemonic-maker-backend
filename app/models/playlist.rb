class Playlist < ApplicationRecord
  belongs_to :user

    def self.create_favorites(user_id)
         @playlist = Playlist.create(title: "Favorites", user_id: user_id)
        if @playlist.valid?
            print('favorites playlist created')
        else
            print("Failed to create favorites playlist")
        end
    end

end
