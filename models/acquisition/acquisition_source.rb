class AcquisitionSource < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "acquisition_sources"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :person, foreign_key: "link_id"
end