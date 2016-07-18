class VesselMarking < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_markings

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view, :marking_method, 
    :marking_location, :description, :note

  custom_attribute :vessel_id, :vbkey
  custom_attribute :type, :marking_type
  custom_attribute :text, :marking_text
  custom_attribute :method, :marking_method
  custom_attribute :location, :marking_location
  custom_attribute :sort, :step

  belongs_to :vessel, foreign_key: "vbkey"
end