class ExhibitionLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibitions_location"

  # specify primary key name
  self.primary_key = "id"
  
  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :location, foreign_key: "loc_id"
end