class Dayte < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "item_dates"

  # specify primary key name
  self.primary_key = "timekey"

  belongs_to :catalog, foreign_key: "mkey"
end