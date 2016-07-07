class CatalogName < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_names

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  # override boolean set
  set_string_columns :attrib_comment

  ignore_columns :step

  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :tna_type
  custom_attribute :scientific_name, :item_name
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :catalog, foreign_key: "mkey"
end