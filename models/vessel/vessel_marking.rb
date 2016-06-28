class VesselMarking < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_markings

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  alias_attribute :type, :marking_type
  alias_attribute :text, :marking_text
  alias_attribute :method, :marking_method
  alias_attribute :location, :marking_location

  custom_attribute :vessel_id, :vbkey

  belongs_to :vessel, foreign_key: "vbkey"
end