class FacilityLevel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facility_levels

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lockey

  ignore_columns :step, :record_view, :level3, :level4, 
    :level5, :level6, :note

  custom_attribute :facility_id, :lockey

  belongs_to :facility, foreign_key: "lockey"
end