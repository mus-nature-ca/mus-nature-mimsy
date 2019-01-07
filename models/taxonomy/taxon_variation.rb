class TaxonVariation < ActiveRecord::Base

  PARSER = ScientificNameParser.new

  # specify schema and table name
  self.table_name = :taxonomy_variations

  # specify primary key name
  self.primary_key = :taxvarkey

  # override decimal set
  set_integer_columns :taxvarkey, :speckey

  ignore_columns :step, :record_view, :certainty

  custom_attribute :id, :taxvarkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :scientific_name, :variation
  custom_attribute :variation_type, :var_type
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :variation_type, :attribution_type

  belongs_to :taxon, foreign_key: "speckey"

  def self.search_by_prefix (prefix)
    self.where("lower(variation) LIKE '#{prefix.downcase}%'")
  end

  def self.hybrids
    self.where("variation LIKE '%×%'")
  end

  def collection
    taxon.collection
  end

  def parsed
    PARSER.parse(scientific_name) rescue {}
  end

end