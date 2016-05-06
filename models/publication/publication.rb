class Publication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :publications

  # specify primary key name
  self.primary_key = :pkey

  # override decimal set
  set_integer_columns :pkey

  # override boolean set
  set_string_columns :illustrated

  custom_attribute :id, :pkey

  has_many :catalogs, through: :catalog_publications, source: :catalog
  has_many :catalog_publications, foreign_key: "pkey"

  has_many :taxa, through: :taxon_publications, source: :taxon
  has_many :taxon_publications, foreign_key: "pkey"

  has_many :sites, through: :site_publications, source: :site
  has_many :site_publications, foreign_key: "pkey"
end