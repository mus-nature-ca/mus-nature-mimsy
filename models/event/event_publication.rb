class EventPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :vkey, :pkey

  custom_attribute :event_id, :vkey
  custom_attribute :publication_id, :pkey

  belongs_to :event, foreign_key: "vkey"
  belongs_to :publication, foreign_key: "pkey"
end