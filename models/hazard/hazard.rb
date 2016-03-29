class Hazard < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "hazard"

  # specify primary key name
  self.primary_key = "hkey"
  
  belongs_to :catalog, primary_key: "hkey", foreign_key: "m_id"
  
  has_many :media, through: :hazard_media, source: :medium
  has_many :hazard_media, foreign_key: "hkey"
end