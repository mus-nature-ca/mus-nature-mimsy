class PersonTaxon < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :people_taxonomy

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :authlinkkey, :link_id, :speckey, :taxvarkey, :nvarkey

  ignore_columns :step, :record_view, :affiliation, :begin_date, :end_date, :portion, :position, :attrib_type, :attributor, :attrib_date, :attrib_source, :certainty, :attrib_comment, :note, :option1, :option2, :option3, :option4, :unlinked_value, :nvarkey, :taxvarkey

  custom_attribute :id, :authlinkkey
  custom_attribute :taxon_id, :speckey
  custom_attribute :taxon_variation_id, :taxvarkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  belongs_to :taxon, foreign_key: "speckey"
  belongs_to :person, foreign_key: "link_id"
end