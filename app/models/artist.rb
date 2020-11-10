class Artist < ApplicationRecord
  has_many :songs

  def self.seed_artist_and_songs(artist_name, genre)
    if Artist.find_by(name: artist_name)
      print "we already have this artist bro"
      return true
    end
    artist = self.create_artist(artist_name, genre)
    if artist == "already have that artist"
      return true
    end
    puts "Searching for songs by #{artist_name}..."
    Song.seed_songs(artist.id)
  end

  def self.create_artist(artist_name, genre)
    response = RestClient.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
    response = JSON.parse(response)
    artist_id = response["response"]["hits"][0]["result"]["primary_artist"]["id"]
    artist_name = response["response"]["hits"][0]["result"]["primary_artist"]["name"]
    if Artist.find_by(name: artist_name)
      return "already have that artist"
    end
    Artist.create(name: artist_name, id: artist_id, genre: genre)
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

  def self.match_to_lyrics(initials, current_song_index, artist_filter = 'any', order, full_query)
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
    
    songs[current_song_index..-1].each_with_index do |song, song_index|
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
          # byebug
          current_song_index+=1

          # byebug
          youtube_id = Song.get_youtube_id(song['full_title'])
          song = song.attributes
          song['youtube_id'] = youtube_id
          # byebug
          return {input_phrase: full_query, matching_phrase: matching_phrase, song: song, current_song_index: current_song_index + song_index, order_matters: order}
          else
            initials_index = 0
            initials_hash_2 = initials_hash.clone 
          matching_phrase = ''
          end
        end
      elsif order 
      # splitting along '/n' will allow contiguous matches across multiple lines
        lyrics.each_with_index do |word, index| 
          if word[0].upcase === initials[initials_index] && initials_index != initials.length
          initials_index += 1
          matching_phrase += "#{word} "
          elsif initials_index == initials.length
          # byebug
          current_song_index += 1
          # byebug 
          youtube_id = Song.get_youtube_id(song['full_title'])
          song = song.attributes
          song['youtube_id'] = youtube_id
          return {input_phrase: full_query, matching_phrase: matching_phrase, song: song, current_song_index: current_song_index + song_index, order_matters: order}
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

  def self.get_response_status(artist_name)
  response = RestClient.get("#{@@base_genius_uri}/search?q=#{artist_name}&access_token=#{ENV['GENIUS_API_KEY']}")
  response = JSON.parse(response)
  status = response["meta"]["status"]
end

  def self.seed_billboard
    artist_array = []
    page_url = "https://www.billboard.com/charts/year-end/2019/top-artists"
    page = Nokogiri::HTML(open(page_url))
        i = 0
        page_array = page.css('div.chart-details').css('article.ye-chart-item').to_a
        while i < page_array.length do
      artist_array.push(page_array[i].css('div.ye-chart-item__title').text.split("\n\n")[1])
      i += 1
        end

        artist_array.each do |artist_name| 
          status = self.get_response_status(artist_name)
          if status == 200
            self.seed_artist_and_songs(artist_name, "billboard top 100")
        end
        # response = JSON.parse(response)
      end
  end

end