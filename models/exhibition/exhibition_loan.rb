class ExhibitionLoan < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions_loans

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :ekey, :lkey, :eikey

  custom_attribute :exhibition_id, :ekey
  custom_attribute :exhibition_catalog_id, :eikey
  custom_attribute :loan_id, :lkey
  custom_attribute :sort, :step

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :loan, foreign_key: "lkey"
end