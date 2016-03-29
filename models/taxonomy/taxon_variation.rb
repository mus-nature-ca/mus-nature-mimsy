class TaxonVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "taxonomy_variations"

  # specify primary key name
  self.primary_key = "taxvarkey"

  belongs_to :taxon, foreign_key: "speckey"

  alias_attribute :scientific_name, :variation
end