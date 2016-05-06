class Right < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :rights

  # specify primary key name
  self.primary_key = :rightskey

  custom_attribute :id, :rightskey
end