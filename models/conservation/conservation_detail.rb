class ConservationDetail < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :conservation_details

  # specify primary key name
  self.primary_key = :consmatkey

  # override decimal set
  set_integer_columns :consmatkey, :conskey

  ignore_columns :step, :record_view, :proposed_treatment, 
    :reason, :action, :begin_date, :end_date, :technique, 
    :result

  custom_attribute :id, :consmatkey
  custom_attribute :conservation_id, :conskey

  belongs_to :conservation, foreign_key: "conskey"
end