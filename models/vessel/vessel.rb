class Vessel < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessels

  # specify primary key name
  self.primary_key = :vbkey

  custom_attribute :id, :vbkey

  has_many :accessories, class_name: "VesselAccessory", foreign_key: "vbkey"

  has_many :catalogs, through: :catalog_vessels, source: :catalog
  has_many :catalog_vessels, foreign_key: "vbkey"

  has_many :components, class_name: "VesselComponent", foreign_key: "vbkey"
  has_many :descriptions, class_name: "VesselDescription", foreign_key: "vbkey"
  has_many :measurements, class_name: "VesselMeasurement", foreign_key: "vbkey"
  has_many :multifields, class_name: "VesselMultifield", foreign_key: "vbkey"
  has_many :names, class_name: "VesselName", foreign_key: "vbkey"
  has_many :other_numbers, class_name: "VesselOtherNumber", foreign_key: "vbkey"
  has_many :statuses, class_name: "VesselStatus", foreign_key: "vbkey"
  has_many :types, class_name: "VesselType", foreign_key: "vbkey"
end