class CatalogMeasurement < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :measurements

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :attrib_type, 
    :attributor, :attrib_date, :attrib_source, 
    :attrib_comment, :certainty

  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :measurement_type
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :part_measured, :unit1, :unit2, :unit3, :unit4, 
    :wunit1, :wunit2, 
    :cunit1, :cunit2, :cunit3, :cunit4, 
    :cwunit1, :cwunit2

  belongs_to :catalog, foreign_key: "mkey"
end