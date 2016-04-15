class CatalogMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_media

  # specify primary key name
  self.primary_keys = :mkey, :mediakey

  # override decimal set
  set_integer_columns :mkey, :mediakey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :medium, foreign_key: "mediakey"
end