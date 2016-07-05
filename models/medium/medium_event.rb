class MediumEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_events

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :vkey, :mediakey, :vvarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :event_id, :vkey
  custom_attribute :event_variation_id, :vvarkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :event, foreign_key: "vkey"
  belongs_to :medium, foreign_key: "mediakey"
end