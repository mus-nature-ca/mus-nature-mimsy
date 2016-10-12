class CatalogOtherNumber < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :other_numbers

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view

  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :on_type
  custom_attribute :sort, :step

  categorical :type

  belongs_to :catalog, foreign_key: "mkey"
end