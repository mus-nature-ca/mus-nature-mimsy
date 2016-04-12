class SitePublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites_publications"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :site, foreign_key: "skey"
  belongs_to :publication, foreign_key: "pkey"
end