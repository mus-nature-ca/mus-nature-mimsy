class PersonContact < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_contacts

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :link_id

  custom_attribute :person_id, :link_id

  belongs_to :person, foreign_key: "link_id"
end