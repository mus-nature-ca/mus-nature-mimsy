class SiteEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_events

  # specify primary key name
  self.primary_keys = :skey, :vkey

  # override decimal set
  set_integer_columns :skey, :vkey

  custom_attribute :site_id, :skey
  custom_attribute :event_id, :vkey

  belongs_to :site, foreign_key: "skey"
  belongs_to :event, foreign_key: "vkey"
end