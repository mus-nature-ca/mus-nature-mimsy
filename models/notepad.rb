class Notepad < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :notepad

  # specify primary key name
  self.primary_key = :id
end