class SitePermit < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "site_permits"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :site, foreign_key: "skey"
end