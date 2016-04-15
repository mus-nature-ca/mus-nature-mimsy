class SiteEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites_events"

  # specify primary key name
  self.primary_key = "authlinkkey"

  # override decimal set
  set_integer_columns :skey, :vkey

  belongs_to :site, foreign_key: "skey"
  belongs_to :event, foreign_key: "vkey"
end