class SubjectVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :subject_variations

  # specify primary key name
  self.primary_key = :svarkey

  # override decimal set
  set_integer_columns :svarkey, :subkey

  custom_attribute :id, :svarkey
  custom_attribute :subject_id, :subkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :subject, foreign_key: "subkey"

  def siblings
    SubjectVariation.where(subkey: subkey).where.not(svarkey: svarkey)
  end
end