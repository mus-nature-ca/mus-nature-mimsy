class SiteMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "sites_media"

  # override decimal set
  set_integer_columns :skey, :mediakey

  belongs_to :site, foreign_key: "skey"
  belongs_to :medium, foreign_key: "mediakey"
end