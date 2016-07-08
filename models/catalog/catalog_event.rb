class CatalogEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_events

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :vkey

  ignore_columns :step, :record_view, :affiliation, :portion, :position, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :note, :option1, :option2, :option3, :option4, :unlinked_value, :vvarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :event_id, :vkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :vkey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :event, foreign_key: "vkey"
end