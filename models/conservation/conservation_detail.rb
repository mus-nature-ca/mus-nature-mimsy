class ConservationDetail < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "conservation_details"

  # specify primary key name
  self.primary_key = "consmatkey"

  belongs_to :conservation, foreign_key: "conskey"
end