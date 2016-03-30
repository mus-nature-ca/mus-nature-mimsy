class Taxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "taxonomy"

  # specify primary key name
  self.primary_key = "speckey"

  belongs_to :parent, class_name: "Taxon", foreign_key: "broader_key1"

  has_many :catalogs, through: :catalog_taxa, source: :taxon
  has_many :catalog_taxa, foreign_key: "speckey"
  has_many :variations, class_name: "TaxonVariation", foreign_key: "speckey"

  has_many :publications, through: :taxon_publications, source: :publication
  has_many :taxon_publications, foreign_key: "speckey"

  alias_attribute :collection, :taxon_name
  alias_attribute :rank, :level_text

  def self.search_by_prefix (prefix)
    self.where("lower(scientific_name) LIKE '#{prefix.downcase}%'")
  end

  def all_synonyms
    variations
  end

  def ancestors
    return enum_for(:ancestors) unless block_given?

    element = self
    while element
      yield element
      element = element.parent
    end
  end

  def root
    ancestors.min
  end

end