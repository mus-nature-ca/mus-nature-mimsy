class CatalogTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_taxonomy"

  # specify primary key name
  self.primary_key = "authlinkkey"

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :taxon, foreign_key: "speckey"

  alias_attribute :identifier, :attributor
  alias_attribute :date_identified, :attrib_date
  alias_attribute :scientific_name, :taxonomy
  alias_attribute :type_status, :affiliation
end