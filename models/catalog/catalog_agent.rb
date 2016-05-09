class CatalogAgent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_people_all

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :link_id

  custom_attribute :catalog_id, :mkey
  custom_attribute :person_id, :link_id

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :person, foreign_key: "link_id"
end