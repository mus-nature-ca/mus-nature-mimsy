class DisposalCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "disposal_items"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :catalog, foreign_key: "m_id"
end