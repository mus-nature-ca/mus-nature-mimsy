class Entry < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :entry

  # specify primary key name
  self.primary_key = :ikey

  custom_attribute :id, :ikey
end