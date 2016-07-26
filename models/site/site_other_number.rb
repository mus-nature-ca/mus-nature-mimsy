class SiteOtherNumber < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_other_numbers

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :skey

  ignore_columns :step, :record_view

  custom_attribute :site_id, :skey
  custom_attribute :type, :site_othnum_type

  categorical :type

  belongs_to :site, foreign_key: "skey"
end