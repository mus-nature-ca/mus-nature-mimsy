class ConditionConservation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :condition_conservation

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :condkey, :conskey

  custom_attribute :condition_id, :condkey
  custom_attribute :conservation_id, :conskey

  belongs_to :condition, foreign_key: "condkey"
  belongs_to :conservation, foreign_key: "conskey"
end