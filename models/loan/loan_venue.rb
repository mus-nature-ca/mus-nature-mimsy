class LoanVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_venues

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :lkey, :link_id

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :person, foreign_key: "link_id"
end