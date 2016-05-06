class Instruction < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :instructions

  # specify primary key name
  self.primary_key = :instructkey

  custom_attribute :id, :instructkey
end