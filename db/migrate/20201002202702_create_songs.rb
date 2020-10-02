class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.integer :artist_id
      t.integer :genius_id
      t.string :lyrics
      t.string :full_title
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end
