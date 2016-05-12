class CatalogEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_events

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :vkey
  
  custom_attribute :catalog_id, :mkey
  custom_attribute :event_id, :vkey

  validates :mkey, :vkey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :event, foreign_key: "vkey"
end