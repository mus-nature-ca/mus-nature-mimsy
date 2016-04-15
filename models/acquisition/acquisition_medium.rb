class AcquisitionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisitions_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :mediakey

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :medium, foreign_key: "mediakey"
end