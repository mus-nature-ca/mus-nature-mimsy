class Entry < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :entry

  # specify primary key name
  self.primary_key = :ikey

  # override decimal set
  set_integer_columns :ikey, :entry_count, :link_id, :nvarkey, :record_view

  custom_attribute :id, :ikey
  custom_attribute :total_objects, :entry_count
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey
end