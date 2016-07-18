class CatalogTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :speckey, :taxvarkey

  ignore_columns :option1, :option2, :option3, :option4, 
    :unlinked_value, :portion, :position, :certainty, 
    :step, :record_view, :begin_date, :end_date

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :taxon_variation_id, :taxvarkey
  custom_attribute :identified_by, :attributor
  custom_attribute :date_identified, :attrib_date
  custom_attribute :identifier_comment, :attrib_comment
  custom_attribute :scientific_name, :taxonomy
  custom_attribute :type_status, :affiliation
  custom_attribute :higher_taxonomy, :broader_text
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_source, :attrib_source
  custom_attribute :sort, :step

  validates :mkey, :speckey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :taxon, foreign_key: "speckey"
end