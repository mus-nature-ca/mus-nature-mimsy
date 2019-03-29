class EventPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :vkey, :placekey

  ignore_columns :step, :specific_locale, :habitat, :relationship, 
    :affiliation, :begin_date, :end_date, :portion, :position, :attrib_type,
    :attrib_date, :attrib_source, :certainty, :attrib_comment, :note,
    :option1, :option2, :option3, :option4, :unlinked_value, :prior_attribution,
    :placevarkey, :vvarkey, :attributor

  custom_attribute :id, :authlinkkey
  custom_attribute :event_id, :vkey
  custom_attribute :place_id, :placekey

  belongs_to :event, foreign_key: "vkey"
  belongs_to :place, foreign_key: "placekey"
end