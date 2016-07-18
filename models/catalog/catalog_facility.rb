class CatalogFacility < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :items_facilities

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :mkey, :lockey

  ignore_columns :step, :record_view, :relationship, 
    :affiliation, :begin_date, :end_date, :portion, 
    :position, :attrib_type, :attributor, :attrib_date, 
    :attrib_source, :certainty, :attrib_comment, :note, 
    :option1, :option2, :option3, :option4, 
    :unlinked_value

  custom_attribute :id, :authlinkkey
  custom_attribute :catalog_id, :mkey
  custom_attribute :facility_id, :lockey
  custom_attribute :parent, :parent_facility
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  validates :mkey, :lockey, presence: true

  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :facility, foreign_key: "lockey"
end