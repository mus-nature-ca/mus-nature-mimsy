class ConditionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "condition_media"

  # override decimal set
  set_integer_columns :condkey, :mediakey

  belongs_to :condition, foreign_key: "condkey"
  belongs_to :medium, foreign_key: "mediakey"
end