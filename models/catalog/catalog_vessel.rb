class CatalogVessel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_vessels

  # specify primary key name
  self.primary_keys = :mkey, :vbkey

  # override decimal set
  set_integer_columns :mkey, :vbkey

  custom_attribute :catalog_id, :mkey
  custom_attribute :vessel_id, :vbkey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :vessel, foreign_key: "vbkey"
end