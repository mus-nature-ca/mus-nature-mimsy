class CatalogInscription < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "inscriptions"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :catalog, foreign_key: "mkey"
end