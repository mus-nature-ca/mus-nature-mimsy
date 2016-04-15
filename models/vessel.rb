class Vessel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessels

  # specify primary key name
  self.primary_key = :vbkey

  has_many :catalogs, through: :catalog_vessels, source: :catalog
  has_many :catalog_vessels, foreign_key: "vbkey"
end