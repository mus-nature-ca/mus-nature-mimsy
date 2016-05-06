class CatalogSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_sites

  # specify primary key name
  self.primary_keys = :mkey, :skey

  # override decimal set
  set_integer_columns :mkey, :skey

  custom_attribute :catalog_id, :mkey
  custom_attribute :site_id, :skey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :site, foreign_key: "skey"
end