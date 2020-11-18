class AddSortedInitialsToLyricSnippets < ActiveRecord::Migration[6.0]
  def change
    add_column :lyric_snippets, :sorted_initials, :string
  end
end
