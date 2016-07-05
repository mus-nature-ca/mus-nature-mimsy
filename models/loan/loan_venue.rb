class LoanVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_venues

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lkey, :link_id, :nvarkey

  custom_attribute :loan_id, :lkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :person, foreign_key: "link_id"
end