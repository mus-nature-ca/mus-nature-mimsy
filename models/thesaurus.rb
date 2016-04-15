class Thesaurus < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :thesaurus

  # specify primary key name
  self.primary_key = :class_id

  has_many :catalogs, through: :catalog_terms, source: :catalog
  has_many :catalg_terms, foreign_key: "class_id"
end