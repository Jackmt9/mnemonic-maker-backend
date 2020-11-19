class AddYoutubeIdToBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :bookmarks, :youtube_id, :string
  end
end
