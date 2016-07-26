class SitePhoto < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_photos

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :skey

  ignore_columns :step, :record_view

  custom_attribute :site_id, :skey

  categorical :photo_type

  belongs_to :site, foreign_key: "skey"
end