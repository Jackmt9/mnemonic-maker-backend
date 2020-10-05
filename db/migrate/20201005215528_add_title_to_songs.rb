class AddTitleToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :title, :string
  end
end
