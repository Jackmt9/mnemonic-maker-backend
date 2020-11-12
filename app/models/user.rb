class User < ApplicationRecord
    has_many :playlists
    has_many :bookmarks, through: :playlists
    has_secure_password
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
end
