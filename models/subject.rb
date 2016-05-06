class Subject < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :subjects

  # specify primary key name
  self.primary_key = :subkey

  custom_attribute :id, :subkey

  has_many :catalogs, through: :catalog_subjects, source: :catalog
  has_many :catalog_subjects, foreign_key: "subkey"
end