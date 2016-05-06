class Person < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people

  # specify primary key name
  self.primary_key = :link_id

  # override decimal set
  set_integer_columns :link_id, :record_view

  # override boolean set
  set_string_columns :gender

  custom_attribute :id, :link_id

  belongs_to :catalog_collector, foreign_key: "link_id"
  
  has_many :catalogs, through: :catalog_agents, source: :catalog
  has_many :catalog_agents, foreign_key: "link_id"

  has_many :collections, through: :catalog_collectors, source: :catalog
  has_many :catalog_collectors, foreign_key: "link_id"

  has_many :acquisitions, through: :acquisition_sources, source: :acquisition
  has_many :acquisition_sources, foreign_key: "link_id"

  has_many :disposals, through: :disposal_sources, source: :disposal
  has_many :disposal_sources, foreign_key: "link_id"

  has_many :loans, through: :loan_venues, source: :loan
  has_many :loan_venues, foreign_key: "link_id"

  has_many :sites, through: :site_people, source: :site
  has_many :site_people, foreign_key: "link_id"

  has_many :variations, class_name: "PersonVariation", foreign_key: "link_id"
end