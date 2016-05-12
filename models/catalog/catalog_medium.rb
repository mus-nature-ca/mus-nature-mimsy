class CatalogMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_media

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :mediakey

  custom_attribute :catalog_id, :mkey
  custom_attribute :medium_id, :mediakey

  validates :mkey, :mediakey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :medium, foreign_key: "mediakey"
end