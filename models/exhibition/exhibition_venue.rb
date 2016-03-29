class ExhibitionVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibition_venues"

  belongs_to :exhibition, foreign_key: "ekey"
end