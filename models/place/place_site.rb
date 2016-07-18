class PlaceSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :skey, :placekey, :step

  ignore_columns :step, :record_view, :specific_locale, :habitat, 
    :relationship, :affiliation, :begin_date, :end_date, :portion, 
    :position, :attrib_type, :attributor, :attrib_date, :attrib_source, 
    :certainty, :attrib_comment, :note, :option1, :option2, :option3, 
    :option4, :unlinked_value, :placevarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :place_id, :placekey
  custom_attribute :site_id, :skey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :skey, :placekey, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :place, foreign_key: "placekey"
end