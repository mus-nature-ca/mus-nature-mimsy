class ExhibitionLoan < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions_loans

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :ekey, :lkey

  custom_attribute :exhibition_id, :ekey
  custom_attribute :loan_id, :lkey

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :loan, foreign_key: "lkey"
end