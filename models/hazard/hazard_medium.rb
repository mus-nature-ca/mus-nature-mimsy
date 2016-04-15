# Table does not exist, but provided here because it is indicated in Tables_Links.pdf
class HazardMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :hazard_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :hkey, :mediakey

  belongs_to :hazard, foreign_key: "hkey"
  belongs_to :media, foreign_key: "mediakey"
end