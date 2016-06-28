class PersonTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :link_id, :speckey

  custom_attribute :taxon_id, :speckey
  custom_attribute :person_id, :link_id

  belongs_to :taxon, foreign_key: "speckey"
  belongs_to :person, foreign_key: "link_id"
end