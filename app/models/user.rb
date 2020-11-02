class User < ApplicationRecord
    has_many :playlists
    has_secure_password
end
