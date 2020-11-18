class AddInitialsToLyricSnippets < ActiveRecord::Migration[6.0]
  def change
    add_column :lyric_snippets, :initials, :string
  end
end
