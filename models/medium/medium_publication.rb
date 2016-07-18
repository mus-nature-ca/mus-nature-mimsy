class MediumPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :pkey, :mediakey

  ignore_columns :step, :record_view, :relationship, 
    :affiliation, :begin_date, :end_date, :portion, 
    :position, :attrib_type, :attributor, :attrib_date, 
    :attrib_source, :certainty, :attrib_comment, :note, 
    :option1, :option2, :option3, :option4, 
    :unlinked_value, :pages

  custom_attribute :id, :authlinkkey
  custom_attribute :publication_id, :pkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :publication, foreign_key: "pkey"
  belongs_to :medium, foreign_key: "mediakey"
end