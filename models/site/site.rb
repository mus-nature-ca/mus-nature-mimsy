class Site < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites"

  # specify primary key name
  self.primary_key = "skey"

  has_many :catalogs, through: :catalog_sites, source: :catalog
  has_many :catalog_sites, foreign_key: "skey"
end