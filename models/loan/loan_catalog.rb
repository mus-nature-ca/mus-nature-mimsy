class LoanCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_items

  # specify primary key name
  self.primary_keys = :m_id, :lkey

  # override decimal set
  set_integer_columns :m_id, :lkey

  custom_attribute :loan_id, :lkey
  custom_attribute :catalog_id, :m_id

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :loan, foreign_key: "lkey"
end