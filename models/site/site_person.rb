class SitePerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_people

  # specify primary key name
  self.primary_keys = :skey, :link_id

  # override decimal set
  set_integer_columns :skey, :link_id

  belongs_to :site, foreign_key: "skey"
  belongs_to :person, foreign_key: "link_id"
end