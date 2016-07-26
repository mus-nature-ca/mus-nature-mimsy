class CatalogMultifield < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :multifields

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view

  custom_attribute :catalog_id, :mkey
  custom_attribute :sort, :step

  categorical :descriptor

  belongs_to :catalog, foreign_key: "mkey"
end