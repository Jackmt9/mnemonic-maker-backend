class Song < ApplicationRecord
     belongs_to :artist

     def self.seed_songs(artist_id)
         page_number=1
        page_cap = 10
        while(page_number <= page_cap && !!page_number) do
            response = RestClient.get("https://genius.com/api/artists/#{artist_id}/songs?page=#{page_number}&sort=popularity")
            response = JSON.parse(response)
            songs = response['response']['songs']
            songs.each do |song|
                print song
            end
            page_number = response['response']['next_page']
        end
     end
end
