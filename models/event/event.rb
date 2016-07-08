class Event < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events

  # specify primary key name
  self.primary_key = :vkey

  # override decimal set
  set_integer_columns :vkey

  ignore_columns :step, :record_view, :display_date, :start_reason, :end_reason, :note, :option1, :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :vkey
  custom_attribute :category, :category1

  has_many :catalogs, through: :catalog_events, source: :catalog
  has_many :catalog_events, foreign_key: "vkey"

  has_many :components, class_name: "EventComponent", foreign_key: "vkey"

  has_many :media, through: :medium_events, source: :medium
  has_many :medium_events, foreign_key: "vkey"

  has_many :people, through: :event_people, source: :person
  has_many :event_people, foreign_key: "vkey"

  has_many :publications, through: :event_publications, source: :publication
  has_many :event_publications, foreign_key: "vkey"

  has_many :sites, through: :site_events, source: :site
  has_many :site_events, foreign_key: "vkey"

  has_many :variations, class_name: "EventVariation", foreign_key: "vkey"
end