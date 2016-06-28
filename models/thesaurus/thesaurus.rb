class Thesaurus < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :thesaurus

  # specify primary key name
  self.primary_key = :class_id

  custom_attribute :id, :class_id
  custom_attribute :parent_id, :broder_id

  belongs_to :parent, class_name: "Thesaurus", foreign_key: "broader_id"

  has_many :catalogs, through: :catalog_terms, source: :catalog
  has_many :catalog_terms, foreign_key: "class_id"

  has_many :children, class_name: "Thesaurus", foreign_key: "broader_id"
  has_many :variations, class_name: "TaxonVariation", foreign_key: "class_id"

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