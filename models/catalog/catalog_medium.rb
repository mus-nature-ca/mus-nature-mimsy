class CatalogMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_media"
  
  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :medium, foreign_key: "mediakey"
end