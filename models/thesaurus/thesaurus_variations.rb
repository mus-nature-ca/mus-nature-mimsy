class ThesaurusVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :thesaurus_variations

  # specify primary key name
  self.primary_key = :thesvarkey

  # override decimal set
  set_integer_columns :thesvarkey, :class_id

  ignore_columns :step, :record_view, :begin_date, :end_date, :note, :attributor, :attrib_type, :attrib_date, :attrib_source, :attrib_comment, :certainty

  custom_attribute :id, :thesvarkey
  custom_attribute :thesaurus_id, :class_id
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :thesaurus, foreign_key: "class_id"

  def siblings
    ThesaurusVariation.where(class_id: class_id).where.not(thesvarkey: thesvarkey)
  end
end