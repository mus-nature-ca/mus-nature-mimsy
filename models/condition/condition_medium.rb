class ConditionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :condition_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :condkey, :mediakey, :m_id

  ignore_columns :step, :record_view, :relationship, 
    :begin_date, :end_date, :note

  custom_attribute :catalog_id, :m_id
  custom_attribute :condition_id, :condkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step

  categorical :condition

  belongs_to :condition, foreign_key: "condkey"
  belongs_to :medium, foreign_key: "mediakey"
  belongs_to :catalog, foreign_key: "m_id"
end