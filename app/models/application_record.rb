class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  @@base_genius_uri = 'https://api.genius.com'
end
