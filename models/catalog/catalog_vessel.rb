class CatalogVessel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_vessels"
  
  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :vessel, foreign_key: "vbkey"
end