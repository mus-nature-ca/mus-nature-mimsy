class CatalogTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_taxonomy

  # specify primary key name
  self.primary_keys = :authlinkkey, :mkey, :speckey

  # override decimal set
  set_integer_columns :mkey, :speckey

  custom_attribute :catalog_id, :mkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :identifier, :attributor
  custom_attribute :date_identified, :attrib_date
  custom_attribute :scientific_name, :taxonomy
  custom_attribute :type_status, :affiliation

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :taxon, foreign_key: "speckey"
end