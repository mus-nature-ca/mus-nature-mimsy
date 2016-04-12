class SiteOtherNumber < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "site_other_numbers"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :site, foreign_key: "skey"
end