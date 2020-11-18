class LyricSnippet < ApplicationRecord
   belongs_to :song
   belongs_to :snippet_tank


   @numHash = {
     "1"=> "o",
     "2"=> "t",
     "3"=> "t",
     "4"=> "f",
     "5"=>"f",
     "6"=>"s",
     "7"=>"s",
     "8"=>"e",
     "9"=>"n"
   }

   def self.new_song_new_snippets(song, lyrics)
    previous_line = ''
      lyrics.each_line do |line|
        print "this line"
        print line
        line_array = line.split(' ')
        print line[0]
        length = line_array.length
        if length == 0 
          next
        end
                  if LyricSnippet.find_by(snippet: line)
                    print "we already have that snippet, homie-------"
                  end
                  if !LyricSnippet.find_by(snippet: line)
                              if line_array[0][0] == '['
                                next
                              end
                              initials = ''
                              line_array.each do |word|
                                letter_index = 0 
                                    if word[0] == "(" && !!word[1]
                                          if word[1] == "'" && !!word[2]
                                        initials += word[2].downcase
                                          else
                                            initials += word[1].downcase
                                          end
                                    elsif @numHash[word[0]]
                                      initials += @numHash[word[0]]  
                                    else
                                    initials += word[0].downcase
                                    end
                              end
                    sorted_initials = initials.split('').sort().join('')
                    new_snippet = LyricSnippet.create(snippet: line, snippet_tank_id: length, song: song, initials: initials, sorted_initials: sorted_initials)     
                  
                  #now that the regular snippet is created, let's create a new snippet combining this snippet with the previous one
                  # double_line = line.concat(previous_line)
                  # double_line_array = double_line.split(' ')
                  # if !LyricSnippet.find_by(snippet: double_line) && double_line_array.length < 15
                  #   double_line_initials = ""
                  #     double_line_array.each do |word|
                  #           letter_index = 0 
                  #             if word[0] == "(" && !!word[1]
                  #                   if word[1] == "'" && !!word[2]
                  #                 double_line_initials += word[2].downcase
                  #                   else
                  #                     double_line_initials += word[1].downcase
                  #                   end
                  #             elsif @numHash[word[0]]
                  #               double_line_initials += @numHash[word[0]]  
                  #             else
                  #             double_line_initials += word[0].downcase
                  #             end
                  #     end
                  #       sorted_double_line_initials = double_line_initials.split('').sort().join('')
                  #     new_double_snippet = LyricSnippet.create(snippet: double_line, snippet_tank_id: length, song: song, initials: double_line_initials, sorted_initials: sorted_double_line_initials) 
                  # end
                  # previous_line = line
                  #set the previous line for the next double_line_snippet

                  #now let's get the fragments of the snippets and use those
                  # if line.split(',').length > 1
                  #   line.split(',').each do |fragment|
                  #     fragment_initials = ''
                  #     fragment.each do |word|
                  #           letter_index = 0 
                  #             if word[0] == "(" && !!word[1]
                  #                   if word[1] == "'" && !!word[2]
                  #                 fragment_initials += word[2].downcase
                  #                   else
                  #                     fragment_initials += word[1].downcase
                  #                   end
                  #             elsif @numHash[word[0]]
                  #               fragment_initials += @numHash[word[0]]  
                  #             else
                  #             fragment_initials += word[0].downcase
                  #             end
                  #         end
                  #     sorted_fragment_initials = fragment_initials.split('').sort().join('')
                  #     new_fragment = LyricSnippet.create(snippet: fragment, snippet_tank_id: length, song: song, initials: fragment_initials, sorted_initials: sorted_fragment_initials) 
                  #   end
                  # end
                  byebug
                end
                  print "created new lyric snippets!"
        end
    end
      
    def self.seed_lyric_snippets
        Song.all[15000..Song.all.length].each do |song|
            song["lyrics"].each_line do |line|
                print "this line" + line
                line_array = line.split(' ')
                # print "this line array #{line_array}"
                print line[0]
                length = line_array.length
                
              if length > 0 
                        if line_array[0][0] == '['
                          next
                        end
                        initials = ''
                          line_array.each do |word|
                            letter_index = 0 
                              if word[0] == "(" && !!word[1]
                                if word[1] == "'" && !!word[2]
                              initials += word[2].downcase
                                else
                                  initials += word[1].downcase
                                end
                              elsif @numHash[word[0]]
                                initials += @numHash[word[0]]  
                              else
                              initials += word[0].downcase
                            end
                          end
                if(!SnippetTank.find_by(id: length))
                  SnippetTank.create(id: length)
                end
                sorted_initials = initials.split('').sort().join('')
                new_lyric = LyricSnippet.create(snippet: line, snippet_tank_id: length, song: song, initials: initials, sorted_initials: sorted_initials) 
                print "creating new lyric snippet! #{new_lyric.snippet} with length: #{length} and a tank id of #{new_lyric.snippet_tank_id}"
              end
            end
          end
      end

  def self.match_initials_to_lyrics(query, current_snippet_index=0, order)
    initials = Artist.get_initials(query)
   downcased_initials = initials.downcase
   if order
    money_lyric_snippets = LyricSnippet.where(initials: downcased_initials)
   else
    sorted_downcased_initials = downcased_initials.sort()
    money_lyric_snippets = LyricSnippet.where(sorted_initials: sorted_downcased_initials)
  end 
  current_snippet = money_lyric_snippets[current_snippet_index]
  song = Song.find(current_snippet.song_id)
  youtube_id = Song.get_youtube_id(song['full_title'])
   song_url = song['url']
  lyrics = Song.get_lyrics(song_url)
  song = song.attributes
  song['youtube_id'] = youtube_id 
  song["lyrics"] = lyrics
    return {input_phrase: query, matching_phrase: current_snippet, song: song} 
    # byebug
      # initials_index = 0
      # matching_phrase = ''
      # byebug
      # money_lyric_snippets.each_with_index do |snippet, snippet_index|
      #       snippet["snippet"].split(' ').each_with_index do |word, index| 
      #         if word[0].upcase === initials[initials_index] && initials_index != initials.length
      #           initials_index += 1
      #           matching_phrase += "#{word} "
      #         elsif initials_index == initials.length
      #           # current_song_index += 1
      #           song = Song.find(snippet.song_id)
      #           youtube_id = Song.get_youtube_id(song['full_title'])
      #           song = song.attributes
      #           song['youtube_id'] = youtube_id 
      #           print "matching phrase is #{matching_phrase} "
      #           return {input_phrase: full_query, matching_phrase: matching_phrase, song: snippet.song_id} 
      #         else
      #           initials_index = 0
      #           matching_phrase = ''
      #         end
      #     end
      #   end
  end

  def self.seed_sorted_initials
    i = 0
    LyricSnippet.all[295000..LyricSnippet.all.length].each do |lyric_snippet|
        if !lyric_snippet.sorted_initials
        snippet_array = lyric_snippet.initials.split('')
        sorted_initials = snippet_array.sort().join('')
        lyric_snippet["sorted_initials"] = sorted_initials
        lyric_snippet.update_attributes(:sorted_initials => sorted_initials)
        # lyric_snippet.save
        # byebug
        end
          if i % 1000 === 0 
            print "yo"
          end
        i += 1
    end
    
  end
end

