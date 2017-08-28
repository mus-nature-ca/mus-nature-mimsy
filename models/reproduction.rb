class Reproduction < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :reproduction

  # specify primary key name
  self.primary_key = :rreqkey

  # override decimal set
  set_integer_columns :rreqkey

  custom_attribute :id, :rreqkey
  custom_attribute :person_id, :link_id

  belongs_to :person, foreign_key: "link_id"
end