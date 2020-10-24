class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.belongs_to :playlist, null: false, foreign_key: true
      t.belongs_to :song, null: false, foreign_key: true
      t.string :input_phrase
      t.string :matching_phrase

      t.timestamps
    end
  end
end
