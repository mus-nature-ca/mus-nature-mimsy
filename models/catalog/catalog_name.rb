class CatalogName < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "item_names"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :catalog, foreign_key: "mkey"

  alias_attribute :scientific_name, :item_name
end