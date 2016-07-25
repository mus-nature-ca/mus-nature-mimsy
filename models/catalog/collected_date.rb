class CollectedDate < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :date_collected

  # specify primary key name
  self.primary_key = :timekey

  # override decimal set
  set_integer_columns :timekey, :mkey

  ignore_columns :step, :record_view, :relationship, 
    :attrib_comment

  custom_attribute :id, :timekey
  custom_attribute :catalog_id, :mkey
  custom_attribute :context, :collection_position
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :century, :period_era

  belongs_to :catalog, foreign_key: "mkey"
end