class EventPerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events_people

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :vkey, :link_id, :nvarkey

  ignore_columns :step, :record_view, :affiliation, :portion, :position, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :option1, :option2, :option3, :option4, :unlinked_value, :nvarkey, :vvarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :event_id, :vkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  belongs_to :event, foreign_key: "vkey"
  belongs_to :person, foreign_key: "link_id"
end