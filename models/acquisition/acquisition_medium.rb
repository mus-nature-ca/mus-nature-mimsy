class AcquisitionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisitions_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :akey, :mediakey

  ignore_columns :step, :record_view, :id_acq, :object, :relationship, :begin_date, :end_date

  custom_attribute :acquisition_id, :akey
  custom_attribute :medium_id, :mediakey

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :medium, foreign_key: "mediakey"
end