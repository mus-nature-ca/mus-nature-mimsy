class GroupMember < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :group_members

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :table_key, :group_id

  ignore_columns :step

  belongs_to :group
end