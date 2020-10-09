class Artist < ApplicationRecord
  has_many :songs
  @@base_genius_uri = 'https://api.genius.com'
    def self.seed_artist_and_songs(artist_name)
        artist = self.create_artist(artist_name)
        puts "Searching for songs by #{artist_name}..."
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
      byebug
    end

    def self.get_initials(query)
      return query.split(' ').map(&:first).join.upcase
    end

    # def self.input_is_matching(initials, song_info)
    #   lyrics = song_info[:lyrics]
    #   initials_index = 0
  
    #   lyrics.split(' ').each_with_index do |lyric, index|
    #       if lyric[0].upcase === initials[initials_index] && initials_index != initials.length
    #           initials_index += 1
    #       elsif initials_index == initials.length
    #           # do we need index? maybe just matching lyrics
    #           # alter p tag to encorporate b tag
    #           song_info[:matching_range] = [index - initials.length, index]
    #           self.add_tag_to_lyrics(song_info)
    #           return true
    #       else
    #           initials_index = 0
    #       end
    #   end
    #   return false
    # end
end
