class LoanLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "loans_location"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :location, foreign_key: "loc_id"
end