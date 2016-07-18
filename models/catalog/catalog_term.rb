class CatalogTerm < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_terms

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :class_id, :thesvarkey

  ignore_columns :step, :record_view, :type_status, :begin_date, 
    :end_date, :portion, :position, :attrib_type, :attributor, 
    :attrib_date, :attrib_source, :certainty, :attrib_comment, 
    :note, :option1, :option2, :option3, :option4, 
    :unlinked_value, :importance, :thesvarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :thesaurus_id, :class_id
  custom_attribute :thesaurus_variation_id, :thesvarkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :class_id, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :thesaurus, foreign_key: "class_id"
end