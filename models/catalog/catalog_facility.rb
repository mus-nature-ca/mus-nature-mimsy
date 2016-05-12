class CatalogFacility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_facilities

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :lockey
  
  custom_attribute :catalog_id, :mkey
  custom_attribute :facility_id, :lockey
  custom_attribute :parent, :parent_facility

  validates :mkey, :lockey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :facility, foreign_key: "lockey"
end