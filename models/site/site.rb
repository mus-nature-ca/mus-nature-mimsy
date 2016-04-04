class Site < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites"

  # specify primary key name
  self.primary_key = "skey"

  has_many :catalogs, through: :catalog_sites, source: :catalog
  has_many :catalog_sites, foreign_key: "skey"

  has_many :measurements, class_name: "SiteMeasurement", foreign_key: "skey"
  
  has_many :places, through: :place_sites, source: :place
  has_many :place_sites, foreign_key: "skey"

  def self.dms_to_dd(coord)
    GeoPoint.new coord
  end

  def dms_to_dd
    GeoPoint.new start_latitude, start_longitude
  end

end