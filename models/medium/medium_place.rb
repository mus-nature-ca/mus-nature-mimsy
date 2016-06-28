class MediumPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :placekey, :mediakey

  custom_attribute :place_id, :placekey
  custom_attribute :medium_id, :mediakey

  belongs_to :place, foreign_key: "placekey"
  belongs_to :medium, foreign_key: "mediakey"
end