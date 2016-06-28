class MediumDescriptor < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_descriptors

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mediakey

  custom_attribute :medium_id, :mediakey

  belongs_to :medium, foreign_key: "mediakey"
end