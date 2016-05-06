class Group < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :groups

  # specify primary key name
  self.primary_key = :group_id

  custom_attribute :id, :group_id
end