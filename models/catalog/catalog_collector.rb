class CatalogCollector < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_collectors

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :link_id, :nvarkey

  ignore_columns :step, :record_view, :begin_date, :end_date, 
    :portion, :attrib_type, :attrib_source, :certainty, 
    :option2, :option3, :option4, :unlinked_value

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :link_id, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :person, foreign_key: "link_id"
end