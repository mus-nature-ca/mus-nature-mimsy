class Dayte < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :item_dates

  # specify primary key name
  self.primary_key = :timekey

  # override decimal set
  set_integer_columns :timekey, :mkey

  ignore_columns :step, :record_view, :date_type, 
    :century, :period_era, :age, :relationship, 
    :attrib_type, :attributor, :attrib_date, 
    :attrib_comment, :attrib_source, :certainty, 
    :dating_method, :context_identifier, :context, 
    :stratigraphic_type, :stratigraphic_unit, :year_dated

  custom_attribute :id, :timekey
  custom_attribute :catalog_id, :mkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :catalog, foreign_key: "mkey"
end