class LoanLocation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loans_location

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lkey, :loc_id, :litmkey

  custom_attribute :loan_id, :lkey
  custom_attribute :location_id, :loc_id
  custom_attribute :loan_catalog_id, :litmkey
  custom_attribute :sort, :step

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :location, foreign_key: "loc_id"
end