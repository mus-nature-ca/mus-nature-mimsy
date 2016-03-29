class LoanMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "loans_media"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :medium, foreign_key: "mediakey"
end