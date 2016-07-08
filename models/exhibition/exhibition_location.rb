class ExhibitionLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions_location

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :ekey, :loc_id, :eikey

  ignore_columns :step, :record_view, :note

  custom_attribute :exhibition_id, :ekey
  custom_attribute :location_id, :loc_id
  custom_attribute :exhibition_catalog_id, :eikey
  custom_attribute :sort, :step

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :location, foreign_key: "loc_id"
end