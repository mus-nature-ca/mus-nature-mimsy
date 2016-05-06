class CatalogMadePlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_places_made

  # specify primary key name
  self.primary_keys = :mkey, :placekey

  # override decimal set
  set_integer_columns :mkey, :placekey

  custom_attribute :catalog_id, :mkey
  custom_attribute :place_id, :placekey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :place, foreign_key: "placekey"
end