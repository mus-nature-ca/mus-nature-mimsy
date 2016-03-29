class LoanCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "loan_items"

  # specify primary key name
  self.primary_key = "litmkey"

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :loan, foreign_key: "lkey"
end