class AcquisitionCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "acquisition_items"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :catalog, foreign_key: "m_id"
end