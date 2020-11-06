class AddDescriptionToPlaylists < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :description, :string
  end
end
