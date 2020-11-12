class LyricSnippet < ApplicationRecord
   belongs_to :song
   belongs_to :snippet_tank

    def self.seed_lyric_snippets
        Song.all.each do |song|
            song["lyrics"].each_line do |line|
                print "this line" + line
                line_array = line.split(' ')
                # print "this line array #{line_array}"
                if(line[0] == '[')
                  next
                end
                length = line_array.length
                if length > 0 
                  if(!SnippetTank.find_by(id: length))
                    SnippetTank.create(id: length)
                  end
                
                  new_lyric = LyricSnippet.create(snippet: line, snippet_tank_id: length, song: song ) 
                  print "creating new lyric snippet! #{new_lyric.snippet} with length: #{length} and a tank id of #{new_lyric.snippet_tank_id}"
                end
            end
        end
    end

  def self.match_initials_to_lyrics(initials, full_query)
   money_length = initials.split('').length
    money_lyric_snippets = SnippetTank.find(money_length).lyric_snippets
      initials_index = 0
      matching_phrase = ''
      # byebug
      money_lyric_snippets.each_with_index do |snippet, snippet_index|
            snippet["snippet"].split(' ').each_with_index do |word, index| 
              if word[0].upcase === initials[initials_index] && initials_index != initials.length
                initials_index += 1
                matching_phrase += "#{word} "
              elsif initials_index == initials.length
                # current_song_index += 1
                song = Song.find(snippet.song_id)
                youtube_id = Song.get_youtube_id(song['full_title'])
                song = song.attributes
                song['youtube_id'] = youtube_id 
                print "matching phrase is #{matching_phrase} "
                return {input_phrase: full_query, matching_phrase: matching_phrase, song: snippet.song_id} 
              else
                initials_index = 0
                matching_phrase = ''
              end
          end
        end
  end
end
