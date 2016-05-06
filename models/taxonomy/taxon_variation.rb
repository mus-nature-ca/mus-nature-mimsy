class TaxonVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :taxonomy_variations

  # specify primary key name
  self.primary_key = :taxvarkey

  # override decimal set
  set_integer_columns :taxvarkey, :speckey

  custom_attribute :taxon_id, :speckey
  custom_attribute :scientific_name, :variation

  belongs_to :taxon, foreign_key: "speckey"

  def self.search_by_prefix (prefix)
    self.where("lower(variation) LIKE '#{prefix.downcase}%'")
  end
end