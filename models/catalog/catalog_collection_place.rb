class CatalogCollectionPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_places_collected

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :placekey, :mplac_id

  ignore_columns :step, :record_view, :affiliation, :begin_date, 
    :end_date, :position, :attrib_type, :attrib_source, 
    :certainty, :option1, :option2, :option3, :option4, 
    :unlinked_value

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :place_id, :placekey
  custom_attribute :place_variation_id, :placevarkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :relationship

  validates :mkey, :placekey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :place, foreign_key: "placekey"
end