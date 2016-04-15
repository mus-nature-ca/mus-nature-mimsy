class RelatedCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "related_items"

  # specify primary key name
  self.primary_key = "relreckey"

  # override decimal set
  set_integer_columns :mkey

  belongs_to :catalog, primary_key: "related_mkey", foreign_key: "mkey"
end