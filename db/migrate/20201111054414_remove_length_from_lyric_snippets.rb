class RemoveLengthFromLyricSnippets < ActiveRecord::Migration[6.0]
  def change
    remove_column :lyric_snippets, :length, :integer
  end
end
