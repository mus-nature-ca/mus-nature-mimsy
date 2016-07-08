class VesselComponent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_components

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey, :quantity

  ignore_columns :step, :record_view, :process, :process_date

  custom_attribute :vessel_id, :vbkey
  custom_attribute :sort, :step

  belongs_to :vessel, foreign_key: "vbkey"
end