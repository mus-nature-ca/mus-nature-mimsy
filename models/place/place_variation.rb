class PlaceVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :place_variations

  # specify primary key name
  self.primary_key = :placevarkey

  # override decimal set
  set_integer_columns :placevarkey, :placekey

  ignore_columns :step, :record_view, :attributor, :attrib_type, :attrib_date, :attrib_source, :attrib_comment, :certainty

  custom_attribute :id, :placevarkey
  custom_attribute :place_id, :placekey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :place, foreign_key: "placekey"

  def siblings
    PlaceVariation.where(placekey: placekey).where.not(placevarkey: placevarkey)
  end
end