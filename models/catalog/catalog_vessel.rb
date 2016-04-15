class CatalogVessel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_vessels

  # specify primary key name
  self.primary_keys = :mkey, :vkey

  # override decimal set
  set_integer_columns :mkey, :vbkey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :vessel, foreign_key: "vbkey"
end