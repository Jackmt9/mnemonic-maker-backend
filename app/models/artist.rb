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

  def self.make_initials_hash(initials_array)
    initials_hash = {}
    initials_array.each do |initial|
      if initials_hash[initial]
      initials_hash[initial] += 1
      else 
        initials_hash[initial] = 1
      end
    end
    return initials_hash
  end

  def self.match_to_lyrics(initials, book_marked_index, artist_filter = 'any', order)
    initials_array = initials.split('')
    initials_hash = self.make_initials_hash(initials_array)
    if artist_filter != 'any'
        artist = Artist.find(artist_filter)
        songs = artist.songs
    else
      songs = Song.all
    end
    initials_index = 0
    matching_phrase = ''
    if !order
      initials_hash_2 = initials_hash.clone 
    end
    
    songs[book_marked_index..-1].each_with_index do |song, song_index|
      if song['title'].split(' ').include?('script' || 'Script')
        next 
      end
      lyrics = song['lyrics'].split(' ' || '\n')
      if !order
        # order_does_not_matter_initials_array = initials_array.clone
        lyrics.each_with_index do |word, index|
          if initials_hash_2[word[0].upcase] && initials_hash_2[word[0].upcase] > 0 && initials_index != initials.length 
          initials_index += 1
          # index = order_does_not_matter_initials_array.index(word[0])
          # order_does_not_matter_initials_array.delete_at(index)
          initials_hash_2[word[0].upcase] -= 1
          matching_phrase += "#{word} "
          elsif initials_index == initials.length 
              
          book_marked_index+=1
          youtube_id = Song.get_youtube_id(song['full_title'])
          song = song.attributes
          song['youtubeId'] = youtube_id
          return {matchingPhrase: matching_phrase, song: song, currentSongIndex: book_marked_index + song_index}
          else
            initials_index = 0
            initials_hash_2 = initials_hash.clone 
          matching_phrase = ''
          end
        end
      elsif order 
      # splitting along '/n' will allow contiguous matches across multiple lines
        lyrics.each_with_index do |word, index|
          # byebug 
          if word[0].upcase === initials[initials_index] && initials_index != initials.length
          initials_index += 1
          matching_phrase += "#{word} "
          elsif initials_index == initials.length
          book_marked_index+=1
          youtube_id = Song.get_youtube_id(song['full_title'])
          song = song.attributes
          song['youtubeId'] = youtube_id
          return {matchingPhrase: matching_phrase, song: song, currentSongIndex: book_marked_index + song_index}
          else
          initials_index = 0
          matching_phrase = ''
          end
        end
      end
    end
    return {error: "No matching text"}
  end

  def self.get_initials(query)
    return query.split(' ').map(&:first).join.upcase
  end
end