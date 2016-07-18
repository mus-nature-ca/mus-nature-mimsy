class RelatedCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :related_items

  # specify primary key name
  self.primary_key = :relreckey

  # override decimal set
  set_integer_columns :relreckey, :mkey

  ignore_columns :step, :record_view, :begin_date, :end_date, 
    :item_summary, :attrib_type, :attributor, :attrib_date, 
    :attrib_source, :certainty, :attrib_comment, 
    :option1, :option2, :option3, :option4

  custom_attribute :id, :relreckey
  custom_attribute :catalog_id, :mkey
  custom_attribute :related_catalog_id, :related_mkey
  custom_attribute :summary, :item_summary
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :catalog, primary_key: "related_mkey", foreign_key: "mkey"
end