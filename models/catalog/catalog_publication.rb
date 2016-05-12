class CatalogPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :pkey

  custom_attribute :catalog_id, :mkey
  custom_attribute :publication_id, :pkey

  validates :mkey, :pkey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :publication, foreign_key: "pkey"
end