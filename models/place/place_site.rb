class PlaceSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_places

  # specify primary key name
  self.primary_keys = :skey, :placekey

  # override decimal set
  set_integer_columns :skey, :placekey

  belongs_to :site, foreign_key: "skey"
  belongs_to :place, foreign_key: "placekey"
end