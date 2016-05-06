class Facility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facilities

  # specify primary key name
  self.primary_key = :lockey

  # override decimal set
  set_integer_columns :lockey

  custom_attribute :id, :lockey

  has_many :catalogs, through: :catalog_facilities, source: :catalog
  has_many :catalog_facilities, foreign_key: "lockey"
end