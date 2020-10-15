class Song < ApplicationRecord
    belongs_to :artist

    def self.seed_songs(artist_id)
        page_number=1
        page_cap = 20
        while(page_number <= page_cap && !!page_number) do
            response = RestClient.get("https://genius.com/api/artists/#{artist_id}/songs?page=#{page_number}&sort=popularity")
            response = JSON.parse(response)
            songs = response['response']['songs']
            self.create_songs(songs, artist_id)
            page_number = response['response']['next_page']
        end
    end

    def self.create_songs(songs, artist_id)
        songs.each do |song|
            if !Song.find_by(title: song['title'])
                puts "Seeding #{song['title']}..."
                song_url = song['url']
                lyrics = self.get_lyrics(song_url)
                Song.create(full_title: song['full_title'], id: (artist_id.to_s + song['id'].to_s).to_i, lyrics: lyrics, artist_id: artist_id, url: song['url'], image: song["song_art_image_url"], title: song['title'])
            end
        end
    end

    def self.get_lyrics(song_url)
      response = RestClient.get(song_url)
      parsed_data = Nokogiri::HTML.parse(response)
      lyrics = parsed_data.css('div.lyrics').text
    end

    def self.get_youtube_url(song_url)
      response = RestClient.get(song_url)
      parsed_data = Nokogiri::HTML.parse(response)
      links = parsed_data.css('a')
      ytps = links.select{|link| link['href'] }
    # ytps_3 = ytps.select {|link| link.values[0].include?('youtube')}    
    # video = ytps_3[1].values[0]
# byebug
    end
end
