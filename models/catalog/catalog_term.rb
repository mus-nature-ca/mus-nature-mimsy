class CatalogTerm < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_terms

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :class_id

  custom_attribute :catalog_id, :mkey
  custom_attribute :thesaurus_id, :class_id

  validates :mkey, :class_id, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :thesaurus, foreign_key: "class_id"
end