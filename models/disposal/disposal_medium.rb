class DisposalMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposals_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :akey, :mediakey

  ignore_columns :step, :record_view, :id_dspl, :object, :relationship, :begin_date, :end_date, :note

  custom_attribute :disposal_id, :akey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :medium, foreign_key: "mediakey"
end