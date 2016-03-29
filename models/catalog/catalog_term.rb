class CatalogTerm < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "items_terms"
  
  belongs_to :catalog, foreign_key: "mkey"
  belongs_to :thesaurus, foreign_key: "class_id"
end