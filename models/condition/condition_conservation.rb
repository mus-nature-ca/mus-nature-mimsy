class ConditionConservation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :condition_conservation

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :m_id, :condkey, :conskey

  ignore_columns :step, :record_view, :note

  custom_attribute :catalog_id, :m_id
  custom_attribute :condition_id, :condkey
  custom_attribute :conservation_id, :conskey
  custom_attribute :sort, :step

  belongs_to :condition, foreign_key: "condkey"
  belongs_to :conservation, foreign_key: "conskey"
  belongs_to :catalog, foreign_key: "m_id"
end