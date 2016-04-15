class MadeDate < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "date_made"

  # specify primary key name
  self.primary_key = "timekey"

  # override decimal set
  set_integer_columns :mkey

  belongs_to :catalog, foreign_key: "mkey"
end