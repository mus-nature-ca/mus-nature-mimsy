class Right < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :rights

  # specify primary key name
  self.primary_key = :rightskey

  # override decimal set
  set_integer_columns :rightskey, :table_key, :link_id

  custom_attribute :id, :rightskey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey
  custom_attribute :regarding, :carryover
  custom_attribute :holder, :rights_holder
  custom_attribute :right, :rights_text
  custom_attribute :status, :rights_status
end