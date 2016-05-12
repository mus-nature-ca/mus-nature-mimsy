class AcquisitionSource < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisition_sources

  # specify primary key name
  self.primary_key = :id

  custom_attribute :acquisition_id, :akey
  custom_attribute :person_id, :link_id

  # override decimal set
  set_integer_columns :id, :link_id, :akey

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :person, foreign_key: "link_id"
end