class SnippetTank < ApplicationRecord
    has_many :lyric_snippets
    def self.seed_the_tank
        
        # snippet_hash = {
        #     1 => [],
        #     2 => [],
        #     3 => [],
        #     4 => [],
        #     5 => [],
        #     6 => [],
        #     7 => [],
        #     8 => [],
        #     9 => [],
        #     10 => [],
        #     11 => [],
        #     12 => [],
        #     13 => [],
        #     14 => [],
        #     15=> [],
        #     16 => [],
        #     17 => [],
        # # }
        # LyricSnippet.all[0..100].each do |snippet|
        #     snippet_array = snippet["snippet"].split(' ')
        #     snippet_array_length = snippet_array.length
        #     if(LyricSnippet.find_by(id: snippet_array_length)){

        #     }

        #     if snippet_array_length > 0
        #         snippet_hash[snippet_array_length].push(snippet)
        #     end
        # end

        # byebug
    end
end
