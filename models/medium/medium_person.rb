class MediumPerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_people

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :link_id, :mediakey

  custom_attribute :person_id, :link_id
  custom_attribute :medium_id, :mediakey

  belongs_to :person, foreign_key: "link_id"
  belongs_to :medium, foreign_key: "mediakey"
end