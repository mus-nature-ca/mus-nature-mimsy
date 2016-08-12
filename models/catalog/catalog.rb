class Catalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :catalogue

  # specify primary key name
  self.primary_key = :mkey

  # override decimal set
  set_integer_columns :mkey, :m_id, :record_view

  ignore_columns :m_id, :record_view, :id_sort1, 
    :id_sort2, :id_sort3, :id_sort4, :id_sort5, 
    :id_sort6, :option8, :option9, :option10, 
    :number1, :number2, :date1, :date2, :extent, 
    :portion, :use, :custodial_history, :appraisal, 
    :arrangement, :access_restrictions, 
    :phystech_requirements, :other_finding_aids, 
    :location_originals, :location_copies, 
    :processing_info, :descriptive_rules, :hazards

  custom_attribute :id, :mkey
  custom_attribute :collection, :category1
  custom_attribute :specimen_nature, :materials
  custom_attribute :acquisition_number, :credit_line
  custom_attribute :scientific_name, :item_name
  custom_attribute :collection_code, :id_prefix
  custom_attribute :catalog_number, :id_number
  custom_attribute :specimen_name, :title
  custom_attribute :geologic_age, :age
  custom_attribute :other_dates, :timeline
  custom_attribute :copies, :item_copies
  custom_attribute :gbif, :flag4
  custom_attribute :gbif_export_date, :date2
  custom_attribute :specimen_nature, :materials

  categorical :collection, :collection_code, :whole_part, :legal_status, 
    :language_of_material, :culture, :condition

  validates :id_number, :category1, presence: true

  has_one :acquisition, through: :acquisition_catalog, source: :acquisition
  has_one :acquisition_catalog, foreign_key: "m_id"

  has_many :agents, through: :catalog_agents, source: :person
  has_many :catalog_agents, foreign_key: "mkey"

  has_one :current_condition, primary_key: "mkey", foreign_key: "m_id"
  has_one :current_legal_status, primary_key: "mkey", foreign_key: "mkey"
  has_one :current_location, primary_key: "mkey", foreign_key: "m_id"

  has_one :disposal, through: :disposal_catalog, source: :disposal
  has_one :disposal_catalog, foreign_key: "m_id"

  has_one :exhibition, through: :exhibition_catalog, source: :exhibition
  has_one :exhibition_catalog, foreign_key: "m_id"

  has_many :accessories, class_name: "CatalogAccessory", foreign_key: "mkey"
  has_many :collected_dates, foreign_key: "mkey"
  
  has_many :collection_places, through: :catalog_collection_places, source: :place
  has_many :catalog_collection_places, foreign_key: "mkey"
  
  has_many :collectors, through: :catalog_collectors, source: :person
  has_many :catalog_collectors, foreign_key: "mkey"
  
  has_many :components, class_name: "CatalogComponent", foreign_key: "mkey"
  has_many :conditions, foreign_key: "m_id"
  has_many :conservations, foreign_key: "m_id"
  has_many :cultures, class_name: "CatalogCulture", foreign_key: "mkey"
  has_many :damages, foreign_key: "m_id"
  has_many :daytes, foreign_key: "mkey"
  has_many :descriptions, class_name: "CatalogDescription", foreign_key: "mkey"
  
  has_many :events, through: :catalog_events, source: :event
  has_many :catalog_events, foreign_key: "mkey"

  has_many :facilities, through: :catalog_facilities, source: :facility
  has_many :catalog_facilities, foreign_key: "mkey"
  
  has_many :hazards, foreign_key: "m_id"
  has_many :inscriptions, class_name: "CatalogInscription", foreign_key: "mkey"

  has_many :loans, through: :loan_catalogs, source: :loan
  has_many :loan_catalogs, foreign_key: "m_id"

  has_many :locations, foreign_key: "m_id"
  has_many :losses, foreign_key: "m_id"
  has_many :made_dates, foreign_key: "mkey"
  
  has_many :made_places, through: :catalog_made_places, source: :place
  has_many :catalog_made_places, foreign_key: "mkey"
  
  has_many :measurements, class_name: "CatalogMeasurement", foreign_key: "mkey"
  
  has_many :media, through: :catalog_media, source: :medium
  has_many :catalog_media, foreign_key: "mkey"
  
  has_many :multifields, class_name: "CatalogMultifield", foreign_key: "mkey"
  has_many :names, class_name: "CatalogName", foreign_key: "mkey"
  has_many :other_measurements, class_name: "CatalogOtherMeasurement", foreign_key: "mkey"
  has_many :other_numbers, class_name: "CatalogOtherNumber", foreign_key: "mkey"
  
  has_many :owners, through: :catalog_owners, source: :person
  has_many :catalog_owners, foreign_key: "mkey"

  has_many :people, through: :catalog_people, source: :person
  has_many :catalog_people, foreign_key: "mkey"
  
  has_many :physical_descriptors, class_name: "CatalogPhysicalDescriptor", foreign_key: "mkey"
  
  has_many :places, through: :catalog_places, source: :place
  has_many :catalog_places, foreign_key: "mkey"
  
  has_many :publications, through: :catalog_publications, source: :publication
  has_many :catalog_publications, foreign_key: "mkey"
  
  has_many :related_catalogs, foreign_key: "mkey"
  
  has_many :sites, through: :catalog_sites, source: :site
  has_many :catalog_sites, foreign_key: "mkey"
  
  has_many :subjects, through: :catalog_subjects, source: :subject
  has_many :catalog_subjects, foreign_key: "mkey"
  
  has_many :taxa, through: :catalog_taxa, source: :taxon
  has_many :catalog_taxa, foreign_key: "mkey"
  
  has_many :terms, through: :catalog_terms, source: :thesaurus
  has_many :catalog_terms, foreign_key: "mkey"
  
  has_many :titles, class_name: "CatalogTitle", foreign_key: "mkey"
  has_many :usages, class_name: "CatalogUsage", foreign_key: "mkey"
  has_many :valuations, foreign_key: "m_id"
  
  has_many :vessels, through: :catalog_vessels, source: :vessel
  has_many :catalog_vessels, foreign_key: "mkey"

  def self.find_by_catalog(id)
    self.find_by_id_number(id)
  end

  def determinations
    names
  end

  def related
    related_catalogs
  end

  def coordinates
    sites.map{ |s| [s.lat, s.lng].compact }.reject { |c| c.empty? }.uniq
  end

end