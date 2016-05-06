class SiteMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_media

  # specify primary key name
  self.primary_keys = :skey, :mediakey

  # override decimal set
  set_integer_columns :skey, :mediakey

  custom_attribute :site_id, :skey
  custom_attribute :medium_id, :mediakey

  belongs_to :site, foreign_key: "skey"
  belongs_to :medium, foreign_key: "mediakey"
end