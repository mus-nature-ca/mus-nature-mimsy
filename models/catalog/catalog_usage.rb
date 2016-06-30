class CatalogUsage < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_usage

  # specify primary key name
  self.primary_key = :usekey

  # override decimal set
  set_integer_columns :usekey, :mkey

  custom_attribute :id, :usekey
  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :use_type
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :catalog, foreign_key: "mkey"
end