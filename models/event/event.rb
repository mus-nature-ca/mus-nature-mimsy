class Event < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "events"

  # specify primary key name
  self.primary_key = "vkey"

  has_many :catalogs, through: :catalog_events, source: :catalog
  has_many :catalog_events, foreign_key: "vkey"
end