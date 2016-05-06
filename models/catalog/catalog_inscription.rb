class CatalogInscription < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :inscriptions

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :mkey
  
  custom_attribute :catalog_id, :mkey

  belongs_to :catalog, foreign_key: "mkey"
end