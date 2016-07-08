class EventPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :vkey, :pkey

  ignore_columns :step, :record_view, :relationship, :affiliation, :begin_date, :end_date, :portion, :position, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :note, :option1, :option2, :option3, :option4, :unlinked_value, :pages, :vvarkey, :publication_date

  custom_attribute :id, :authlinkkey
  custom_attribute :event_id, :vkey
  custom_attribute :publication_id, :pkey
  custom_attribute :illustrated, :illustration
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :event, foreign_key: "vkey"
  belongs_to :publication, foreign_key: "pkey"
end