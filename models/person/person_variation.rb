class PersonVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_variations

  # specify primary key name
  self.primary_key = :nvarkey

  # override decimal set
  set_integer_columns :link_id

  custom_attribute :id, :nvarkey
  custom_attribute :person_id, :link_id

  belongs_to :person, foreign_key: "link_id"
end