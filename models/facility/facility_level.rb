class FacilityLevel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :facility_levels

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lockey

  custom_attribute :facility_id, :lockey

  belongs_to :facility, foreign_key: "lockey"
end