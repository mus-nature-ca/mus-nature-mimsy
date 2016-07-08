class VesselMeasurement < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_measurements

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view

  custom_attribute :vessel_id, :vbkey
  custom_attribute :length_overall, :loa
  custom_attribute :length_overall_unit, :loa_unit
  custom_attribute :gross_tonnage, :weight1
  custom_attribute :gross_tonnage_unit, :wunit1
  custom_attribute :net_tonnage, :weight2
  custom_attribute :net_tonnage_unit, :wunit2
  custom_attribute :sort, :step

  belongs_to :vessel, foreign_key: "vbkey"
end