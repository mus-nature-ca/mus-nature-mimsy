class DamageMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "damage_media"

  # specify primary key name
  self.primary_key = "id"

  belongs_to :damage, foreign_key: "dkey"
  belongs_to :media, foreign_key: "mediakey"
end