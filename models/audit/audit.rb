class Audit < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :audits

  # specify primary key name
  self.primary_key = :audkey
end