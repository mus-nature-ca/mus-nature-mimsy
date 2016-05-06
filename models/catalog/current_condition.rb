class CurrentCondition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :current_condition

  # specify primary key name
  self.primary_key = :m_id

  # override decimal set
  set_integer_columns :m_id

  custom_attribute :catalog_id, :m_id

  belongs_to :catalog, foreign_key: "m_id"
end