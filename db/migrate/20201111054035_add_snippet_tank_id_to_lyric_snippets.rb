class AddSnippetTankIdToLyricSnippets < ActiveRecord::Migration[6.0]
  def change
    add_column :lyric_snippets, :snippet_tank_id, :integer
  end
end
