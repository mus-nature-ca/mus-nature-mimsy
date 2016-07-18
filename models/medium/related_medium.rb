class RelatedMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :related_media

  # specify primary key name
  self.primary_key = :relreckey

  # override decimal set
  set_integer_columns :relreckey, :mediakey, :related_mediakey

  ignore_columns :step, :record_view, :relationship, :begin_date, 
    :end_date, :note, :item_summary, :attrib_type, :attributor, 
    :attrib_date, :attrib_source, :certainty, :attrib_comment, 
    :option1, :option2, :option3, :option4

  custom_attribute :id, :relreckey
  custom_attribute :medium_id, :mediakey
  custom_attribute :related_medium_id, :related_mediakey
  custom_attribute :summary, :item_summary
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :medium, primary_key: "related_mediakey", foreign_key: "mediakey"
end