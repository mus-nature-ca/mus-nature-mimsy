class Taxon < ActiveRecord::Base

  PARSER = ScientificNameParser.new

  # specify schema and table name
  self.table_name = :taxonomy

  # specify primary key name
  self.primary_key = :speckey

  # override decimal set
  set_integer_columns :speckey, :broader_key1, :mtax_id, :hierarchy_level, :record_view

  ignore_columns :step, :record_view, :mtax_id, :common_name, :broader_name, 
    :lifecycle, :gestation, :birth_rate, :seasonality, :reproduction_note, 
    :diet, :behavior, :social_organization, :conservation, :threats, 
    :population, :population_date, :option2, :option3, :option4, :number1, 
    :number2, :date1, :date2, :sort_name

  custom_attribute :id, :speckey
  custom_attribute :parent_path, :male_single_parent
  custom_attribute :second_parent_path, :female_multi_parent
  custom_attribute :parent_id, :broader_key1
  custom_attribute :collection, :taxon_name
  custom_attribute :rank, :level_text
  custom_attribute :authority, :source

  categorical :rank, :collection, :endangered_status

  validates :taxon_name, presence: true

  belongs_to :parent, class_name: "Taxon", foreign_key: "broader_key1"

  has_many :children, class_name: "Taxon", foreign_key: "broader_key1"

  has_many :catalogs, through: :catalog_taxa, source: :catalog
  has_many :catalog_taxa, foreign_key: "speckey"

  has_many :media, through: :medium_taxa, source: :medium
  has_many :medium_taxa, foreign_key: "speckey"

  has_many :people, through: :person_taxa, source: :person
  has_many :person_taxa, foreign_key: "speckey"

  has_many :publications, through: :taxon_publications, source: :publication
  has_many :taxon_publications, foreign_key: "speckey"

  has_many :variations, class_name: "TaxonVariation", foreign_key: "speckey", dependent: :destroy

  def self.search_by_prefix (prefix)
    self.where("lower(scientific_name) LIKE '#{prefix.downcase}%'")
  end

  def self.hybrids
    self.where("scientific_name LIKE '%×%' OR level_text = 'hybrid'")
  end

  def synonyms
    variations
  end

  def ancestors
    @ancestors ||= begin
      node, nodes = self, []
      nodes << node = node.parent while node.parent
      nodes.reverse
    end
  end

  def descendants
    children.map do |child|
      [child] + child.descendants
    end.flatten
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

  def self_and_descendants
    [self] + self.descendants
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

  def has_catalogs?
    !catalogs.size.zero?
  end

  def parsed
    PARSER.parse(scientific_name) rescue {}
  end

  def parent_path_ids
    ancestors.map(&:id)
  end

  def parent_path_ranks
    ancestors.map(&:rank)
  end

end