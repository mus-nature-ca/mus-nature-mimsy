class PlaceSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites_places"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :site, foreign_key: "skey"
  belongs_to :place, foreign_key: "placekey"
end