class CatalogSubject < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_subjects"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :subject, foreign_key: "subkey"
end