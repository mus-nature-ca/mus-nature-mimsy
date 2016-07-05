class Dispatch < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :dispatch

  # specify primary key name
  self.primary_key = :dispkey

  # override decimal set
  set_integer_columns :displey

  custom_attribute :id, :dispkey
end