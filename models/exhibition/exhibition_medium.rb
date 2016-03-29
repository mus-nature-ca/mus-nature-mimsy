class ExhibitionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibitions_media"

  # specify primary key name
  self.primary_key = "id"
  
  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :media, foreign_key: "mediakey"
end