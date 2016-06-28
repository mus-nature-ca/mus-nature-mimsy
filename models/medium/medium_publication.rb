class MediumPublication < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media_publications

  # specify primary key name
  self.primary_key = :authlinkkey

  # override decimal set
  set_integer_columns :pkey, :mediakey

  custom_attribute :publication_id, :pkey
  custom_attribute :medium_id, :mediakey

  belongs_to :publication, foreign_key: "pkey"
  belongs_to :medium, foreign_key: "mediakey"
end