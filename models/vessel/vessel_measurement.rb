class VesselMeasurement < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_measurements

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  custom_attribute :vessel_id, :vbkey

  belongs_to :vessel, foreign_key: "vbkey"
end