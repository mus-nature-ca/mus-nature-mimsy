class Dispatch < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "dispatch"

  # specify primary key name
  self.primary_key = "dispkey"
end