class PersonPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :link_id, :pkey

  custom_attribute :publication_id, :pkey
  custom_attribute :person_id, :link_id

  belongs_to :publication, foreign_key: "pkey"
  belongs_to :person, foreign_key: "link_id"
end