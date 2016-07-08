class LoanMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loans_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lkey, :mediakey, :litmkey

  ignore_columns :step, :record_view, :litmkey, :object, :relationship, :begin_date, :end_date, :note

  custom_attribute :loan_id, :lkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :loan_catalog_id, :litmkey
  custom_attribute :sort, :step

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :medium, foreign_key: "mediakey"
end