class VesselOtherNumber < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_other_numbers

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view

  custom_attribute :vessel_id, :vbkey
  custom_attribute :sort, :step

  belongs_to :vessel, foreign_key: "vbkey"
end