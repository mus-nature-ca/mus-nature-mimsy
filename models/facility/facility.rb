class Facility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facilities

  # specify primary key name
  self.primary_key = :lockey

  # override decimal set
  set_integer_columns :lockey

  custom_attribute :id, :lockey
  custom_attribute :address_line1, :address1
  custom_attribute :address_line2, :address2
  custom_attribute :address_line3, :address3
  custom_attribute :facility_manager, :location_manager

  has_many :catalogs, through: :catalog_facilities, source: :catalog
  has_many :catalog_facilities, foreign_key: "lockey"
end