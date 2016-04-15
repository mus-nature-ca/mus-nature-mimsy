class ExhibitionVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibition_venues"

  # override decimal set
  set_integer_columns :ekey

  belongs_to :exhibition, foreign_key: "ekey"
end