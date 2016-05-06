class SitePublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_publications

  # specify primary key name
  self.primary_keys = :skey, :pkey

  # override decimal set
  set_integer_columns :skey, :pkey

  custom_attribute :site_id, :skey
  custom_attribute :publication_id, :pkey

  belongs_to :site, foreign_key: "skey"
  belongs_to :publication, foreign_key: "pkey"
end