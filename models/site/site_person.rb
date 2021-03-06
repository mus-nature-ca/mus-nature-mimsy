class SitePerson < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :sites_people

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :skey, :link_id

  ignore_columns :step, :record_view, :portion, :position, 
    :attrib_type, :attributor, :attrib_date, :attrib_source, 
    :certainty, :attrib_comment, :option1, :option2, 
    :option3, :option4, :unlinked_value

  custom_attribute :id, :authlinkkey
  custom_attribute :site_id, :skey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey
  custom_attribute :sort, :step
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  categorical :relationship

  validates :skey, :link_id, presence: true

  belongs_to :site, foreign_key: "skey"
  belongs_to :person, foreign_key: "link_id"
end