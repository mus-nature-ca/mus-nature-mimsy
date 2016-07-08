class CatalogPhysicalDescriptor < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :physical_descriptors

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :class_id, :descriptor_type

  custom_attribute :catalog_id, :mkey
  custom_attribute :value, :term
  custom_attribute :sort, :step
  custom_attribute :type, :descriptor_type

  belongs_to :catalog, foreign_key: "mkey"
end