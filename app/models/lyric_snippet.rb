class LyricSnippet < ApplicationRecord
   belongs_to :song

    def self.seed_lyric_snippets
        Song.all.each do |song|
            song["lyrics"].each_line do |line|
                print "this line" + line
                line_array = line.split(' ')
                # print "this line array #{line_array}"
                if(line_array[0][0] == '[')
                  
                  next
                end
                length = line_array.length
                # print song.id
                new_lyric = LyricSnippet.create(snippet: line, length: length, song: song ) 
                print "creating new lyric snippet! #{new_lyric.snippet}"
            end
        end
    end

  def  self.match_initials_to_lyrics(initials, full_query)
    money_length = initials.length
    money_lyric_snippets = LyricSnippet.all.select do |snippet| 
      snippet.length == money_length
    end
            initials_index = 0
          matching_phrase = ''
          money_lyric_snippets.each do |snippet|
            # byebug
            print "original snippet #{snippet["snippet"]}"
            snippet["snippet"].split(' ').each_with_index do |word, index| 
              print word
              if word[0].upcase === initials[initials_index] && initials_index != initials.length
                initials_index += 1
                matching_phrase += "#{word} "
              elsif initials_index == initials.length
                # byebug
                # current_song_index += 1
                # byebug 
                song = Song.find(snippet.song_id)
                youtube_id = Song.get_youtube_id(song['full_title'])
                song = song.attributes
                song['youtube_id'] = youtube_id
                print "matching phrase is #{matching_phrase}"
                return {input_phrase: full_query, matching_phrase: matching_phrase, song: snippet.song_id} 
                # current_song_index: current_song_index + song_index, order_matters: order}
              else
                initials_index = 0
                matching_phrase = ''
              end
          end
        end
  end
end
