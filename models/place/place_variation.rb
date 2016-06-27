class PlaceVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :place_variations

  # specify primary key name
  self.primary_key = :placevarkey

  # override decimal set
  set_integer_columns :placevarkey, :placekey

  belongs_to :place, foreign_key: "placekey"

  def siblings
    PlaceVariation.where(placekey: placekey).where.not(placevarkey: placevarkey)
  end
end