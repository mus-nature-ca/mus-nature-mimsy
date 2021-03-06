class Action < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :actions

  # specify primary key name
  self.primary_key = :actkey

  # override decimal set
  set_integer_columns :id, :actkey

  custom_attribute :id, :actkey
end