class CatalogUsage < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_usage

  # specify primary key name
  self.primary_key = :usekey

  # override decimal set
  set_integer_columns :mkey

  custom_attribute :catalog_id, :mkey

  belongs_to :catalog, foreign_key: "mkey"
end