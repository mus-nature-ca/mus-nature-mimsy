class MediumEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_events

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :vkey, :mediakey

  custom_attribute :event_id, :vkey
  custom_attribute :medium_id, :mediakey

  belongs_to :event, foreign_key: "vkey"
  belongs_to :medium, foreign_key: "mediakey"
end