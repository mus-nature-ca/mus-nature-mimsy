class Facility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facilities

  # specify primary key name
  self.primary_key = :lockey

  # override decimal set
  set_integer_columns :lockey, :record_view

  custom_attribute :id, :lockey
  custom_attribute :address_line1, :address1
  custom_attribute :address_line2, :address2
  custom_attribute :address_line3, :address3
  custom_attribute :facility_manager, :location_manager
  custom_attribute :type, :loc_type
  custom_attribute :manager, :location_manager
  custom_attribute :length, :loc_length
  custom_attribute :dimension_unit, :dim_unit

  has_many :catalogs, through: :catalog_facilities, source: :catalog
  has_many :catalog_facilities, foreign_key: "lockey"

  has_many :levels, class_name: "FacilityLevel", foreign_key: "lockey"
  has_many :locations, class_name: "Location", foreign_key: "lockey"
end