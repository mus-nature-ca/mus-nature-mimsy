class CurrentLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :current_location

  # specify primary key name
  self.primary_key = :loc_id

  # override decimal set
  set_integer_columns :loc_id, :m_id

  custom_attribute :catalog_id, :m_id
  custom_attribute :location_id, :loc_id
  custom_attribute :facility_id, :lockey

  belongs_to :catalog, primary_key: "m_id", foreign_key: "m_id"
  belongs_to :location, primary_key: "loc_id", foreign_key: "loc_id"
  belongs_to :facility, primary_key: "lockey", foreign_key: "lockey"
end