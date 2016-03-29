class Place < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "places"

  # specify primary key name
  self.primary_key = "placekey"

  has_many :catalogs, through: :catalog_places, source: :catalog
  has_many :catalog_places, foreign_key: "placekey"
  
  has_many :collected_catalogs, through: :catalog_collection_places, source: :catalog
  has_many :catalog_collection_places, foreign_key: "placekey"
  
  has_many :made_catalogs, through: :catalog_made_places, source: :catalog
  has_many :catalog_made_places, foreign_key: "placekey"
end