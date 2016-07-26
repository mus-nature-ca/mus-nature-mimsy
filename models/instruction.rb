class Instruction < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :instructions

  # specify primary key name
  self.primary_key = :instructkey

  # override decimal set
  set_integer_columns :instructkey, :table_key

  ignore_columns :step, :record_view, :instruction_by, 
    :instruction_for, :optimal_value

  custom_attribute :id, :instructkey
  custom_attribute :type, :instruction_type
  custom_attribute :regarding, :carryover

  categorical :type
end