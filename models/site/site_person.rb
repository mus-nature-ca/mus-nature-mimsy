class SitePerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites_people"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :site, foreign_key: "skey"
  belongs_to :person, foreign_key: "link_id"
end