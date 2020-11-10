class Song < ApplicationRecord
    belongs_to :artist
    # @@base_genius_uri = 'https://api.genius.com'

    def self.seed_songs(artist_id)
        page_number=1
        page_cap = 5
        while(page_number <= page_cap) do
            response = RestClient.get("https://genius.com/api/artists/#{artist_id}/songs?page=#{page_number}&sort=popularity")
            response = JSON.parse(response)
            songs = response['response']['songs']
            self.create_songs(songs, artist_id)
            page_number = response['response']['next_page']
            if !page_number
                break
            end
        end
    end

    def self.create_songs(songs, artist_id)
        songs.each do |song|
            # if Artist.songs.all.find(artist_id: artist_id)
            #     next
            # end
            print "song id is #{song["id"]} "
            if !Song.find_by(id: song["id"])
                begin
                puts "Seeding #{song['title']}..."
                song_url = song['url']
                lyrics = self.get_lyrics(song_url)
                Song.create(full_title: song['full_title'], lyrics: lyrics, artist_id: artist_id, url: song['url'], image: song["song_art_image_url"], title: song['title'])
                rescue
                    puts "rescued!"
                    next
                end
            end
        end
    end

    def self.get_lyrics(song_url)
      response = RestClient.get(song_url)
      parsed_data = Nokogiri::HTML.parse(response)
      lyrics = parsed_data.css('div.lyrics').text
    end

    def self.get_youtube_id(full_title)
        youtube_search_page = "https://www.youtube.com/results?search_query=#{full_title}"
        response = RestClient.get(URI.encode(youtube_search_page))
        parsed_data = Nokogiri::HTML.parse(response) 
        youtube_id = parsed_data.css('body').to_s.split("watch?v=")[1].split("\"")[0]
        # youtube_link = "https://www.youtube.com/watch?v=#{youtube_id}&feature=emb_rel_err"
        return youtube_id
    end

end
