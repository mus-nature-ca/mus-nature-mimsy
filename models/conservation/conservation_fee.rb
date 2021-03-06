class ConservationFee < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :conservation_fees

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :conskey, :consmatkey

  custom_attribute :conservation_id, :conskey
  custom_attribute :conservation_detail_id, :consmatkey

  belongs_to :conservation, foreign_key: "conskey"
end