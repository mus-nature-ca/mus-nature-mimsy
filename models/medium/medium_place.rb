class MediumPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :placekey, :mediakey, :placevarkey

  ignore_columns :step, :record_view, :relationship, :affiliation, 
    :begin_date, :end_date, :portion, :position, :attrib_type, 
    :attributor, :attrib_date, :attrib_source, :certainty, 
    :attrib_comment, :note, :option1, :option2, :option3, 
    :option4, :unlinked_value, :placevarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :place_id, :placekey
  custom_attribute :place_variation_id, :placevarkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :place, foreign_key: "placekey"
  belongs_to :medium, foreign_key: "mediakey"
end