class SiteMeasurement < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_measurements

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :skey

  custom_attribute :site_id, :skey
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :site, foreign_key: "skey"
end