class Event < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "events"

  # specify primary key name
  self.primary_key = "vkey"

  # override decimal set
  set_integer_columns :vkey

  has_many :catalogs, through: :catalog_events, source: :catalog
  has_many :catalog_events, foreign_key: "vkey"
  
  has_many :events, through: :site_events, source: :site
  has_many :site_events, foreign_key: "vkey"
end