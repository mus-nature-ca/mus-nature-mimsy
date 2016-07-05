class SiteEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_events

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :skey, :vkey

  custom_attribute :id, :authlinkkey
  custom_attribute :site_id, :skey
  custom_attribute :event_id, :vkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :skey, :vkey, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :event, foreign_key: "vkey"
end