class Person < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people

  # specify primary key name
  self.primary_key = :link_id

  # override decimal set
  set_integer_columns :link_id, :record_view, :mpeo_id

  # override boolean set
  set_string_columns :gender

  ignore_columns :mpeo_id, :step, :record_view, :flag1, :flag2, :option1, 
    :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :link_id
  custom_attribute :title, :title_name
  custom_attribute :first_name, :firstmid_name
  custom_attribute :last_name, :lastsuff_name
  custom_attribute :suffix, :suffix_name
  custom_attribute :contacts, :people_contacts

  categorical :language, :title, :honorary_suffix, :gender, :cause_of_death,
    :nationality, :assessment

  belongs_to :catalog_collector, foreign_key: "link_id"

  belongs_to :insurance, foreign_key: "link_id"

  belongs_to :reproduction, foreign_key: "link_id"

  has_many :catalogs, through: :catalog_agents, source: :catalog
  has_many :catalog_agents, foreign_key: "link_id"

  has_many :collections, through: :catalog_collectors, source: :catalog
  has_many :catalog_collectors, foreign_key: "link_id"

  has_many :contacts, class_name: "PersonContact", foreign_key: "link_id"

  has_many :acquisitions, through: :acquisition_sources, source: :acquisition
  has_many :acquisition_sources, foreign_key: "link_id"

  has_many :biographies, foreign_key: "link_id", source: :person_biography

  has_many :disposals, through: :disposal_sources, source: :disposal
  has_many :disposal_sources, foreign_key: "link_id"

  has_many :events, through: :event_people, source: :event
  has_many :event_people, foreign_key: "link_id"

  has_many :loans, foreign_key: "link_id", source: :loan
  has_many :loan_venues, foreign_key: "link_id"

  has_many :media, through: :medium_people, source: :medium
  has_many :medium_people, foreign_key: "link_id"

  has_many :places, through: :person_places, source: :place
  has_many :person_places, foreign_key: "link_id"

  has_many :publications, through: :person_publications, source: :publication
  has_many :person_publications, foreign_key: "link_id"

  has_many :sites, through: :site_people, source: :site
  has_many :site_people, foreign_key: "link_id"

  has_many :taxa, through: :person_taxa, source: :taxon
  has_many :person_taxa, foreign_key: "link_id"

  has_many :variations, class_name: "PersonVariation", foreign_key: "link_id"

  def self.search_by_prefix (prefix)
    self.where("lower(preferred_name) LIKE '#{prefix.downcase}%'")
  end

end