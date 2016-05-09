class Audit < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :audits

  # specify primary key name
  self.primary_key = :audkey

  custom_attribute :id, :audkey
  custom_attribute :number_missing, :number_not_found
  custom_attribute :reason, :audit_reason
end