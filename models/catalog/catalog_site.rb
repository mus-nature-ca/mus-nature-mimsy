class CatalogSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_sites"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :site, foreign_key: "skey"
end