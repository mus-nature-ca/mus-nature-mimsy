class CatalogPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_publications

  # specify primary key name
  self.primary_keys = :mkey, :pkey

  # override decimal set
  set_integer_columns :mkey, :pkey

  custom_attribute :catalog_id, :mkey
  custom_attribute :publication_id, :pkey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :publication, foreign_key: "pkey"
end