class Subject < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :subjects

  # specify primary key name
  self.primary_key = :subkey

  # override decimal set
  set_integer_columns :subkey, :msub_id, :record_view

  custom_attribute :id, :subkey

  has_many :catalogs, through: :catalog_subjects, source: :catalog
  has_many :catalog_subjects, foreign_key: "subkey"

  has_many :variations, class_name: "SubjectVariation", foreign_key: "subkey", dependent: :destroy
end