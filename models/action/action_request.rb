class ActionRequest < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :action_request

  # specify primary key name
  self.primary_key = :actreqkey

  custom_attribute :id, :actreqkey
end