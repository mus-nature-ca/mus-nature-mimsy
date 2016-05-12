class CatalogSubject < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_subjects

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :subkey

  custom_attribute :catalog_id, :mkey
  custom_attribute :subject_id, :subkey

  validates :mkey, :subkey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :subject, foreign_key: "subkey"
end