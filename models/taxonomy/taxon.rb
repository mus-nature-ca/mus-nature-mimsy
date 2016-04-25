class Taxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :taxonomy

  # specify primary key name
  self.primary_key = :speckey

  # override decimal set
  set_integer_columns :speckey, :broader_key1

  alias_attribute :collection, :taxon_name
  alias_attribute :rank, :level_text
  alias_attribute :authority, :source

  validates :taxon_name, presence: true

  belongs_to :parent, class_name: "Taxon", foreign_key: "broader_key1"

  has_many :children, class_name: "Taxon", foreign_key: "broader_key1"

  has_many :catalogs, through: :catalog_taxa, source: :catalog
  has_many :catalog_taxa, foreign_key: "speckey"
  has_many :variations, class_name: "TaxonVariation", foreign_key: "speckey"

  has_many :publications, through: :taxon_publications, source: :publication
  has_many :taxon_publications, foreign_key: "speckey"

  def self.search_by_prefix (prefix)
    self.where("lower(scientific_name) LIKE '#{prefix.downcase}%'")
  end

  def synonyms
    variations
  end

  def ancestors
    node, nodes = self, []
    nodes << node = node.parent while node.parent
    nodes.reverse
  end

  def descendants
    children.each_with_object(children.to_a) {|child, arr|
      arr.concat child.descendants
    }.uniq
  end

  def siblings
    self_and_siblings - [self]
  end

  def self_and_siblings
    parent.children
  end

  def self_and_ancestors
    [self] + self.ancestors
  end

  def root
    node = self
    node = node.parent while node.parent
    node
  end

  def root?
    parent.nil?
  end

  def leaf?
    children.size.zero?
  end

end