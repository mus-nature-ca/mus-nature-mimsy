class ConservationFee < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "conservation_fees"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :conservation, foreign_key: "conskey"
end