class SiteCollection < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_collections

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :skey

  ignore_columns :step, :record_view

  custom_attribute :site_id, :skey

  categorical :count_type, :collection_type

  belongs_to :site, foreign_key: "skey"
end