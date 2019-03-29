class TaxonEvent < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :events_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :speckey, :vkey

  ignore_columns :step, :record_view, :affiliation, :begin_date, 
    :end_date, :portion, :position, :attrib_type, :attributor, 
    :attrib_date, :attrib_source, :certainty, :attrib_comment, 
    :option1, :option2, :option3, :option4, :unlinked_value, 
    :pages, :relationship, :vvarkey, :note, :prior_attribution

  custom_attribute :id, :authlinkkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :taxon_variation_id, :taxvarkey
  custom_attribute :event_id, :vkey
  custom_attribute :parent_path, :broader_text
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :speckey, :vkey, presence: true

  belongs_to :taxon, foreign_key: "speckey"
  belongs_to :event, foreign_key: "vkey"
end