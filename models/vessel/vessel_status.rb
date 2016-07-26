class VesselStatus < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :vessel_status

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :vbkey

  ignore_columns :step, :record_view, :provenance_summary

  custom_attribute :vessel_id, :vbkey

  categorical :legal_status, :collection

  belongs_to :vessel, foreign_key: "vbkey"
end