class Location < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "location"

  # specify primary key name
  self.primary_key = "loc_id"

  # override decimal set
  set_integer_columns :m_id

  belongs_to :catalog, primary_key: "loc_id", foreign_key: "m_id"
  
  has_many :exhibitions, through: :exhibition_locations, source: :exhibition
  has_many :exibition_locations, foreign_key: "loc_id"
  
  has_many :loans, through: :loan_locations, source: :loan
  has_many :loan_locations, foreign_key: "loc_id"
end