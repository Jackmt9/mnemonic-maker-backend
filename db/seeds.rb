artists = ['The Beatles', 'Eric Clapton']
Artist.seed_artist_and_songs(artists)

puts "Creating User --- email: admin@gmail.com, password: admin"
user = User.create(first_name: 'admin', last_name: 'admin', email: 'admin@gmail.com', password: 'admin')

puts "Creating Playlists"
playlists = ['Chemistry', 'Biology', 'Astronomy']
playlists.each do |title|
    playlist = Playlist.create(title: title, user: user)
    puts "Playlist #{title} created"


    # Populate playlists with bookmarks here
end

puts "--- SEEDING COMPLETE ---"