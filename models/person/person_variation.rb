class PersonVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_variations

  # specify primary key name
  self.primary_key = :nvarkey

  # override decimal set
  set_integer_columns :nvarkey, :link_id

  ignore_columns :step, :record_view, :attrib_type, 
    :attributor, :attrib_date, :attrib_comment, :certainty

  custom_attribute :id, :nvarkey
  custom_attribute :person_id, :link_id
  custom_attribute :type, :nvar_type
  custom_attribute :attribution_type, :attrib_type
  custom_attribute :attribution_date, :attrib_date
  custom_attribute :attribution_comment, :attrib_comment
  custom_attribute :attribution_source, :attrib_source

  belongs_to :person, foreign_key: "link_id"
end