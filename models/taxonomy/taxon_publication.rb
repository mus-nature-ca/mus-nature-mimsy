class TaxonPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :taxonomy_publications

  # specify primary key name
  self.primary_keys = :speckey, :pkey

  # override decimal set
  set_integer_columns :speckey, :pkey

  belongs_to :taxon, foreign_key: "speckey"
  belongs_to :publication, foreign_key: "pkey"
end