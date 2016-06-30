class CatalogAccessory < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :accessories

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  custom_attribute :catalog_id, :mkey
  custom_attribute :sort, :step

  belongs_to :catalog, foreign_key: "mkey"
end