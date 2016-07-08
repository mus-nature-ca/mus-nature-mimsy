class PersonPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :link_id, :placekey, :placevarkey, :nvarkey

  ignore_columns :step, :record_view, :relationship, :affiliation, :begin_date, :end_date, :portion, :position, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :note, :option1, :option2, :option3, :option4, :unlinked_value, :nvarkey, :placevarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :place_id, :placekey
  custom_attribute :place_variation_id, :placevarkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :place, foreign_key: "placekey"
  belongs_to :person, foreign_key: "link_id"
end