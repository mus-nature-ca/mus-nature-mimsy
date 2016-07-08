class CatalogSite < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_sites

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :skey

  ignore_columns :step, :record_view, :affiliation, :begin_date, :end_date, :portion, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :option1, :option2, :option3, :option4, :unlinked_value

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :site_id, :skey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :skey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :site, foreign_key: "skey"
end