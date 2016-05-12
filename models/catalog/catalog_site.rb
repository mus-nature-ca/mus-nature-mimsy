class CatalogSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_sites

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :skey

  custom_attribute :catalog_id, :mkey
  custom_attribute :site_id, :skey

  validates :mkey, :skey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :site, foreign_key: "skey"
end