class Artist < ApplicationRecord
  has_many :songs

    def self.seed_artist_and_songs(artist_name)
      artist = self.create_artist(artist_name)
      puts "Searching for songs by #{artist_name}..."
      Song.seed_songs(artist.id)
    end

    def self.create_artist(artist_name)
      response = RestClient.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
      response = JSON.parse(response)
      artist_id = response["response"]["hits"][0]["result"]["primary_artist"]["id"]
      artist_name = response["response"]["hits"][0]["result"]["primary_artist"]["name"]
      Artist.create(name: artist_name, id: artist_id)
    end

    def self.match_to_lyrics(initials, book_marked_index, artist_filter = 'any')
      if artist_filter != 'any'
        songs = Song.all.select do |song|
          song.artist_id == artist_filter
        end
      else
        songs = Song.all
      end

      initials_index = 0
      matching_phrase = ''

      songs[book_marked_index..-1].each_with_index do |song, song_index|
        lyrics = song['lyrics'].split(' ' || '\n')
        # splitting along '/n' will allow contiguous matches across multiple lines
        lyrics.each_with_index do |word, index|
          if word[0].upcase === initials[initials_index] && initials_index != initials.length
            initials_index += 1
            matching_phrase += "#{word} "
          elsif initials_index == initials.length
            book_marked_index+=1
            print "bookmark ", book_marked_index
            print "regular ", song_index
            youtube_id = Song.get_youtube_url(song['full_title'])
            return {matching_phrase: matching_phrase, song: song, current_song_index: book_marked_index + song_index, youtube_id: youtube_id}
          else
            initials_index = 0
            matching_phrase = ''
          end
        end
      end

      return {error: "No matching text"}
    end

    def self.get_initials(query)
      return query.split(' ').map(&:first).join.upcase
    end

end