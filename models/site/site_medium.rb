class SiteMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_media

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :skey, :mediakey

  custom_attribute :site_id, :skey
  custom_attribute :medium_id, :mediakey

  validates :skey, :mediakey, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :medium, foreign_key: "mediakey"
end