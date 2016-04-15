class CatalogFacility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_facilities"

  # override decimal set
  set_integer_columns :mkey, :lockey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :facility, foreign_key: "lockey"
end