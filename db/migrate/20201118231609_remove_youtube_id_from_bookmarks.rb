class RemoveYoutubeIdFromBookmarks < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookmarks, :youtube_id, :integer
  end
end
