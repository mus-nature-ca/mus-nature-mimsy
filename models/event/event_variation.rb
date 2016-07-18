class EventVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :event_variations

  # specify primary key name
  self.primary_key = :vvarkey

  # override decimal set
  set_integer_columns :vvarkey, :vkey

  ignore_columns :step, :record_view, :begin_date, :end_date, 
    :note, :attributor, :attrib_date, :attrib_source, 
    :certainty, :attrib_type, :attrib_comment

  custom_attribute :id, :vvarkey
  custom_attribute :event_id, :vkey
  custom_attribute :type, :variation_type
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :event, foreign_key: "vkey"
end