class CatalogEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_events"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :event, foreign_key: "vkey"
end