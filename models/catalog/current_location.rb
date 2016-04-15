class CurrentLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :current_location

  # specify primary key name
  self.primary_key = :loc_id

  # override decimal set
  set_integer_columns :m_id

  belongs_to :catalog, foreign_key: "m_id"
end