class EventComponent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :event_components

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vkey

  custom_attribute :event_id, :vkey

  belongs_to :event, foreign_key: "vkey"
end