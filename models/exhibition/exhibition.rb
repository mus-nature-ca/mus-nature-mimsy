class Exhibition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibitions"

  # specify primary key name
  self.primary_key = "ekey"

  # override decimal set
  set_integer_columns :ekey

  has_many :catalogs, through: :exhibition_catalogs, source: :catalog
  has_many :exhibition_catalogs, foreign_key: "ekey"

  has_many :loans, through: :exhibition_loans, source: :loan
  has_many :exhibition_loans, foreign_key: "ekey"

  has_many :locations, through: :exhibition_locations, source: :location
  has_many :exhibition_locations, foreign_key: "ekey"

  has_many :media, through: :exhibition_media, source: :medium
  has_many :exhibition_media, foreign_key: "ekey"

  has_many :themes, foreign_key: "ekey"
  has_many :venues, foreign_key: "ekey"
end