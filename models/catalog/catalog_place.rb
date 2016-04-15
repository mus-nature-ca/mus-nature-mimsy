class CatalogPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_places"

  # specify primary key name
  self.primary_key = "authlinkkey"

  # override decimal set
  set_integer_columns :mkey, :placekey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :place, foreign_key: "placekey"
end