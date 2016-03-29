class CatalogOwner < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_owners"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :person, foreign_key: "link_id"
end