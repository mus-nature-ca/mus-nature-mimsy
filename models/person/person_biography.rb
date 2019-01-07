class PersonBiography < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_dates

  # specify primary key name
  self.primary_key = :timekey

  # override decimal set
  set_integer_columns :timekey

  ignore_columns :period_era, :relationship, :attrib_type, :attributor, :attrib_date,
    :attrib_comment, :attrib_source, :certainty, :step

  custom_attribute :id, :timekey
  custom_attribute :person_id, :link_id

  belongs_to :person, foreign_key: "link_id"
end