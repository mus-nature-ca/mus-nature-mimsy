class CatalogDescription < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_descriptions

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :descript_source, 
    :attrib_type, :attributor, :attrib_date, 
    :attrib_source, :attrib_comment, :certainty, :note

  custom_attribute :catalog_id, :mkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source
  custom_attribute :description_type, :description_type
  custom_attribute :description_date, :descript_date
  custom_attribute :description_source, :descript_source

  categorical :description_type

  belongs_to :catalog, foreign_key: "mkey"
end