class SiteMap < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_maps

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :skey

  custom_attribute :site_id, :skey

  belongs_to :site, foreign_key: "skey"
end