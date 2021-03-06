class VesselType < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_types

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view

  custom_attribute :vessel_id, :vbkey
  custom_attribute :type, :vt_type
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :type, :prior_type, :vessel_type, :attribution_type
    :certainty

  belongs_to :vessel, foreign_key: "vbkey"
end