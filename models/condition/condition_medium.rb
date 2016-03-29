class ConditionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "condition_media"
  
  belongs_to :condition, foreign_key: "condkey"
  belongs_to :medium, foreign_key: "mediakey"
end