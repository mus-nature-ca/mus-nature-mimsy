class CatalogName < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_names

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :mkey

  custom_attribute :catalog_id, :mkey

  alias_attribute :scientific_name, :item_name

  belongs_to :catalog, foreign_key: "mkey"
end