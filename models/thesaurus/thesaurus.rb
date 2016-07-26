class Thesaurus < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :thesaurus

  # specify primary key name
  self.primary_key = :class_id

  # override decimal set
  set_integer_columns :class_id, :mthes_id, :record_view, :broader_id

  ignore_columns :step, :record_view, :term1_2, :term2_2, :term3_2, :sort2, 
    :other_sort, :option1, :option2, :number1, :number2, :date1, :date2, :mthes_id

  custom_attribute :id, :class_id
  custom_attribute :parent_id, :broader_id
  custom_attribute :term, :term1_1
  custom_attribute :alternate1, :term2_1
  custom_attribute :alternate2, :term3_1
  custom_attribute :term_alt_lang, :term1_2
  custom_attribute :alternate1_alt_lang, :term2_2
  custom_attribute :alternate2_alt_lang, :term3_2
  custom_attribute :level, :hierarchy_level
  custom_attribute :thesaurus_system, :thes_system

  categorical :language, :thesaurus_system

  belongs_to :parent, class_name: "Thesaurus", foreign_key: "broader_id"

  has_many :children, class_name: "Thesaurus", foreign_key: "broader_id"
  has_many :catalogs, through: :catalog_terms, source: :catalog
  has_many :catalog_terms, foreign_key: "class_id"
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