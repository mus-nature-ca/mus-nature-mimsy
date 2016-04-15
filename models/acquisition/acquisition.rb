class Acquisition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisitions

  # specify primary key name
  self.primary_key = :akey

  has_many :catalogs, through: :acquisition_catalogs, source: :catalog
  has_many :acquisition_catalogs, foreign_key: "akey"

  has_many :sources, through: :acquisition_sources, source: :person
  has_many :acquisition_sources, foreign_key: "akey"

  has_many :media, through: :acquisition_media, source: :medium
  has_many :acquisition_media, foreign_key: "akey"
end