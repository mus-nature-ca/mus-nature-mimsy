class CatalogSubject < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_subjects

  # specify primary key name
  self.primary_keys = :mkey, :subkey

  # override decimal set
  set_integer_columns :mkey, :subkey

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :subject, foreign_key: "subkey"
end