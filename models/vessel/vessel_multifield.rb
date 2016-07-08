class VesselMultifield < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_multifields

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view

  custom_attribute :vessel_id, :vbkey

  belongs_to :vessel, foreign_key: "vbkey"
end