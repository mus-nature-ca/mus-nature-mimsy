class ExhibitionCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibition_items"

  # specify primary key name
  self.primary_key = "eikey"
  
  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :catalog, foreign_key: "m_id"
end