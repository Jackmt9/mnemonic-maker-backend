class Artist < ApplicationRecord
  has_many :songs

  def self.seed_artist_and_songs(artists)
    artists.each do |artist|
      new_artist = self.create_artist(artist)
      puts "Created entry for #{new_artist.name}..."
      puts "Searching for songs by #{artist}..."
      Song.seed_songs(new_artist.id)
    end
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

  def self.get_songs_by_artist_id(artist_filter)
    if artist_filter != 'any'
      artist = Artist.find(artist_filter)
      return songs = artist.songs
    else
      return songs = Song.all
    end
  end

  def self.query_with_order(initials, current_song_index, lyrics, song, song_index)
    initials_index = 0
    matching_phrase = ''
    
    lyrics.each_with_index do |word, index| 
      if word[0].upcase === initials[initials_index] && initials_index != initials.length
        initials_index += 1
        matching_phrase += "#{word} "
      elsif initials_index == initials.length
        current_song_index += 1
        youtube_id = Song.get_youtube_id(song['full_title'])
        song = song.attributes
        song['youtube_id'] = youtube_id
        return {matching_phrase: matching_phrase, song: song, current_song_index: current_song_index + song_index}
      else
        initials_index = 0
        matching_phrase = ''
      end
    end
    return false
  end
  
  def self.query_without_order(initials, current_song_index, lyrics, song, song_index)
    initials_index = 0
    matching_phrase = ''

    initials_array = initials.split('')
    initials_hash = self.make_initials_hash(initials_array)
    initials_hash_2 = initials_hash.clone 

    lyrics.each_with_index do |word, index|
      if initials_hash_2[word[0].upcase] && initials_hash_2[word[0].upcase] > 0 && initials_index != initials.length 
        initials_index += 1
        initials_hash_2[word[0].upcase] -= 1
        matching_phrase += "#{word} "
      elsif initials_index == initials.length 
        current_song_index += 1
        youtube_id = Song.get_youtube_id(song['full_title'])
        song = song.attributes
        song['youtube_id'] = youtube_id
        return {matching_phrase: matching_phrase, song: song, current_song_index: current_song_index + song_index}
      else
        initials_index = 0
        initials_hash_2 = initials_hash.clone 
        matching_phrase = ''
      end
    end
    return false
  end

  def self.match_to_lyrics(query, current_song_index, artist_filter = 'any', order)
    initials = self.get_initials(query)

    # Set songs to array of queryable songs based on artist filter
    songs = self.get_songs_by_artist_id(artist_filter)
    
    matching_info = false
    
    songs[current_song_index..-1].each_with_index do |song, song_index|
      lyrics = song['lyrics'].split(' ' || '\n')
      if order
        matching_info = self.query_with_order(initials, current_song_index, lyrics, song, song_index)
      else
        matching_info = self.query_without_order(initials, current_song_index, lyrics, song, song_index)
      end

      if matching_info
          matching_info["input_phrase"] = query
          return matching_info
      end
    end

    return {error: "No matching text"} 
  end

  def self.get_initials(query)
    return query.split(' ').map(&:first).join.upcase
  end
end