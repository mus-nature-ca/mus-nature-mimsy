class CatalogLegalStatus < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :legal_status

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :provenance_summary

  custom_attribute :catalog_id, :mkey

  belongs_to :catalog, foreign_key: "mkey"
end