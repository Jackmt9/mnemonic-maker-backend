artists = ['The Beatles', 'Eric Clapton']
Artist.seed_artist_and_songs(artists)
puts "Creating User --- email: admin@gmail.com, password: admin"
User.create(first_name: 'admin', last_name: 'admin', email: 'admin@gmail.com', password: 'admin')
puts "--- SEEDING COMPLETE ---"