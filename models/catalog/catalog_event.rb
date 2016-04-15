class CatalogEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_events

  # specify primary key name
  self.primary_keys = :mkey, :vkey

  # override decimal set
  set_integer_columns :mkey, :vkey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :event, foreign_key: "vkey"
end