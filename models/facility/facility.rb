class Facility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facilities

  # specify primary key name
  self.primary_key = :lockey

  # override decimal set
  set_integer_columns :lockey, :record_view

  ignore_columns :step, :record_view, :address2, :address3, :telephone, 
    :fax, :location_manager, :emergency_contact, :emergency_phone, 
    :note, :policy_number, :maximum_object_value, :maximum_total_value, 
    :height, :width, :loc_length, :dim_unit, :maximum_load_weight, 
    :weight_unit, :dock_dimensions, :elevator_dimensions, 
    :doorway_dimensions, :low_humidity, :high_humidity, :humidity_unit, 
    :low_radiation, :high_radiation, :radiation_unit, :low_temperature, 
    :high_temperature, :temperature_unit, :low_uv, :high_uv, :uv_unit, 
    :low_lux, :high_lux, :lux_unit, :low_pollutants, :high_pollutants, 
    :pollutants_unit, :restrictions, :option1, :option2, :number1, 
    :number2, :date1, :date2

  custom_attribute :id, :lockey
  custom_attribute :parent_id, :broader_lockey
  custom_attribute :address_line1, :address1
  custom_attribute :address_line2, :address2
  custom_attribute :address_line3, :address3
  custom_attribute :facility_manager, :location_manager
  custom_attribute :type, :loc_type
  custom_attribute :manager, :location_manager
  custom_attribute :length, :loc_length
  custom_attribute :dimension_unit, :dim_unit

  categorical :type

  has_many :catalogs, through: :catalog_facilities, source: :catalog
  has_many :catalog_facilities, foreign_key: "lockey"

  has_many :levels, class_name: "FacilityLevel", foreign_key: "lockey"
  has_many :locations, class_name: "Location", foreign_key: "lockey"
end