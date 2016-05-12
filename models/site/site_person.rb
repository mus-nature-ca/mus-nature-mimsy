class SitePerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_people

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :skey, :link_id

  custom_attribute :site_id, :skey
  custom_attribute :person_id, :link_id

  validates :skey, :link_id, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :person, foreign_key: "link_id"
end