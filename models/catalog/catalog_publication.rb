class CatalogPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_publications"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :publication, foreign_key: "pkey"
end