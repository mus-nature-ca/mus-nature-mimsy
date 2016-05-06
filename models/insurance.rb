class Insurance < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :insurance

  # specify primary key name
  self.primary_key = :inskey

  custom_attribute :id, :inskey
end