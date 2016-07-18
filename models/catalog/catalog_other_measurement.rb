class CatalogOtherMeasurement < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :other_measurements

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :attrib_type, 
    :attributor, :attrib_date, :attrib_source, 
    :attrib_comment, :certainty

  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :om_type
  custom_attribute :size, :size_measure
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :catalog, foreign_key: "mkey"
end