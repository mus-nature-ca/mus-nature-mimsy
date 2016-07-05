class SitePerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_people

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :skey, :link_id

  custom_attribute :id, :authlinkkey
  custom_attribute :site_id, :skey
  custom_attribute :person_id, :link_id
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :skey, :link_id, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :person, foreign_key: "link_id"
end