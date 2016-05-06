class ConditionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :condition_media

  # specify primary key name
  self.primary_keys = :condkey, :mediakey

  # override decimal set
  set_integer_columns :condkey, :mediakey

  custom_attribute :condition_id, :condkey
  custom_attribute :medium_id, :mediakey

  belongs_to :condition, foreign_key: "condkey"
  belongs_to :medium, foreign_key: "mediakey"
end