class CatalogTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :mkey, :speckey

  custom_attribute :catalog_id, :mkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :identified_by, :attributor
  custom_attribute :date_identified, :attrib_date
  custom_attribute :identifier_comment, :attrib_comment
  custom_attribute :scientific_name, :taxonomy
  custom_attribute :type_status, :affiliation
  custom_attribute :higher_taxonomy, :broader_text

  validates :mkey, :speckey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :taxon, foreign_key: "speckey"
end