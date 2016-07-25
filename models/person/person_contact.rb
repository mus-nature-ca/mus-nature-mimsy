class PersonContact < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_contacts

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :link_id

  ignore_columns :step, :record_view, :contact_other

  custom_attribute :person_id, :link_id

  categorical :address_type, :salutation, :country

  belongs_to :person, foreign_key: "link_id"
end