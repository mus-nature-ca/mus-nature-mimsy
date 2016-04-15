class Disposal < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "disposals"

  # specify primary key name
  self.primary_key = "akey"

  # override decimal set
  set_integer_columns :akey

  has_many :catalogs, through: :disposal_catalogs, source: :catalog
  has_many :disposal_catalogs, foreign_key: "akey"

  has_many :sources, through: :disposal_sources, source: :person
  has_many :disposal_sources, foreign_key: "akey"

  has_many :media, through: :disposal_media, source: :medium
  has_many :disposal_media, foreign_key: "akey"
end