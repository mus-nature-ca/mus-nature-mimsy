class CurrentCondition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :current_condition

  # specify primary key name
  self.primary_key = :m_id

  # override decimal set
  set_integer_columns :m_id, :condkey

  ignore_columns :step, :record_view, :external_file, 
    :option1, :option2, :number1, :number2, 
    :date1, :date2

  custom_attribute :catalog_id, :m_id
  custom_attribute :condition_id, :condkey

  categorical :purpose, :status

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :condition, foreign_key: "condkey"
end