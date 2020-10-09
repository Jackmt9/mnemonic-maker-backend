require 'rest-client'
class Artist < ApplicationRecord
  has_many :songs
  @@base_genius_uri = 'https://api.genius.com'
    def self.seed_artist_and_songs(artist_name)
        artist = self.create_artist(artist_name)
        Song.seed_songs(artist.genius_id)
    end

    def self.create_artist(artist_name)
        response = RestClient.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
        response = JSON.parse(response)
        artist_id = response["response"]["hits"][0]["result"]["primary_artist"]["id"]
        artist_name = response["response"]["hits"][0]["result"]["primary_artist"]["name"]
        Artist.create(id: artist_id, name: artist_name, genius_id: artist_id)
    end

    def self.match_to_lyrics(query)
      return 'yoo'
    end
end
