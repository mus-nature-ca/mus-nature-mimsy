class CatalogMadePlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_places_made"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :place, foreign_key: "placekey"
end