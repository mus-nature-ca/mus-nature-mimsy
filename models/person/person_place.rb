class PersonPlace < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_places

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :link_id, :placekey

  custom_attribute :place_id, :placekey
  custom_attribute :person_id, :link_id

  belongs_to :place, foreign_key: "placekey"
  belongs_to :person, foreign_key: "link_id"
end