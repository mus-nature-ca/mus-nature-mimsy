class CatalogMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_media

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :mediakey

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :mediakey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :medium, foreign_key: "mediakey"
end