class CatalogFacility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_facilities

  # specify primary key name
  self.primary_keys = :mkey, :lockey

  # override decimal set
  set_integer_columns :mkey, :lockey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :facility, foreign_key: "lockey"
end