class Site < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites

  # specify primary key name
  self.primary_key = :skey

  # override decimal set
  set_integer_columns :skey

  custom_attribute :id, :skey

  validates :site_id, presence: true

  has_many :catalogs, through: :catalog_sites, source: :catalog
  has_many :catalog_sites, foreign_key: "skey"

  has_many :collections, class_name: "SiteCollection", foreign_key: "skey"
  has_many :coordinates, class_name: "SiteCoordinate", foreign_key: "skey"
  has_many :cultures, class_name: "SiteCulture", foreign_key: "skey"

  has_many :descriptions, class_name: "SiteDescription", foreign_key: "skey"

  has_many :events, through: :site_events, source: :event
  has_many :site_events, foreign_key: "skey"

  has_many :excavations, class_name: "SiteExcavation", foreign_key: "skey"

  has_many :features, class_name: "SiteFeature", foreign_key: "skey"
  has_many :maps, class_name: "SiteMap", foreign_key: "skey"
  has_many :measurements, class_name: "SiteMeasurement", foreign_key: "skey"

  has_many :media, through: :site_media, source: :medium
  has_many :site_media, foreign_key: "skey"
  
  has_many :other_numbers, class_name: "SiteOtherNumber", foreign_key: "skey"

  has_many :permits, class_name: "SitePermit", foreign_key: "skey"

  has_many :people, through: :site_people, source: :person
  has_many :site_people, foreign_key: "skey"

  has_many :photos, class_name: "SitePhoto", foreign_key: "skey"
  
  has_many :places, through: :place_sites, source: :place
  has_many :place_sites, foreign_key: "skey"

  has_many :publications, through: :site_publications, source: :publication
  has_many :site_publications, foreign_key: "skey"

  has_many :surveys, class_name: "SiteSurvey", foreign_key: "skey"

  def lat
    start_latitude_dec.present? ? start_latitude_dec.to_f : nil
  end

  def lng
    start_longitude_dec.present? ? start_longitude_dec.to_f : nil
  end

  def has_coordinates?
    start_latitude_dec.present? && start_longitude_dec.present?
  end

  def is_point?
    has_coordinates? && (end_latitude_dec.nil? || end_longitude_dec.nil?)
  end

  def is_bbox?
    !bbox[0].nil? && !bbox[2].nil? && bbox[0] != bbox[2]
  end

  # [minx, miny, maxx, maxy]
  def bbox
    minx = start_longitude_dec.present? ? start_longitude_dec.to_f : nil
    miny = start_latitude_dec.present? ? start_latitude_dec.to_f : nil
    maxx = end_longitude_dec.present? ? end_longitude_dec.to_f : minx
    maxy = end_latitude_dec.present? ? end_latitude_dec.to_f : miny
    lats = [miny, maxy].sort
    lngs = [minx, maxx].sort
    [lngs[0], lats[0], lngs[1], lats[1]]
  end
end