class MediumTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :speckey, :mediakey

  custom_attribute :taxon_id, :speckey
  custom_attribute :medium_id, :mediakey

  belongs_to :taxon, foreign_key: "speckey"
  belongs_to :medium, foreign_key: "mediakey"
end