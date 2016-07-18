class Place < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :places

  # specify primary key name
  self.primary_key = :placekey

  # override decimal set
  set_integer_columns :mplac_id, :record_view, :broader_key

  ignore_columns :step, :record_view, :start_latitude_dec, 
    :start_longitude_dec, :end_latitude_dec, :end_longitude_dec, 
    :elevation, :elevation_unit, :elevation_direction, 
    :elevation_accuracy, :population, :population_date, :option1, 
    :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :placekey
  custom_attribute :name, :place1

  belongs_to :parent, class_name: "Place", foreign_key: "broader_key"

  has_many :children, class_name: "Place", foreign_key: "broader_key"

  has_many :catalogs, through: :catalog_places, source: :catalog
  has_many :catalog_places, foreign_key: "placekey"
  
  has_many :collected_catalogs, through: :catalog_collection_places, source: :catalog
  has_many :catalog_collection_places, foreign_key: "placekey"
  
  has_many :made_catalogs, through: :catalog_made_places, source: :catalog
  has_many :catalog_made_places, foreign_key: "placekey"

  has_many :media, through: :medium_places, source: :place
  has_many :medium_places, foreign_key: "placekey"

  has_many :people, through: :person_places, source: :person
  has_many :person_places, foreign_key: "placekey"

  has_many :sites, through: :place_sites, source: :site
  has_many :place_sites, foreign_key: "placekey"

  has_many :variations, class_name: "PlaceVariation", foreign_key: "placekey", dependent: :destroy

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