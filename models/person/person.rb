class Person < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "people"

  # specify primary key name
  self.primary_key = "link_id"

  has_many :collectors, through: :catalog_collectors, source: :catalog
  has_many :catalog_collectors, foreign_key: "link_id"
  
  has_many :catalogs, through: :catalog_people, source: :catalog
  has_many :catalog_people, foreign_key: "link_id"
  
  has_many :makers, through: :catalog_makers, source: :catalog
  has_many :catalog_makers, foreign_key: "link_id"

  has_many :acquisitions, through: :acquisition_sources, source: :acquisition
  has_many :acquisition_sources, foreign_key: "link_id"

  has_many :disposals, through: :disposal_sources, source: :disposal
  has_many :disposal_sources, foreign_key: "link_id"

  has_many :loans, through: :loan_venues, source: :loan
  has_many :loan_venues, foreign_key: "link_id"
end