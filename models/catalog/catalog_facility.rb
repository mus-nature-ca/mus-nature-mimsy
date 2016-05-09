class CatalogFacility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_facilities

  # specify primary key name
  self.primary_keys = :mkey, :lockey

  # override decimal set
  set_integer_columns :mkey, :lockey
  
  custom_attribute :catalog_id, :mkey
  custom_attribute :facility_id, :lockey
  custom_attribute :parent, :parent_facility

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :facility, foreign_key: "lockey"
end