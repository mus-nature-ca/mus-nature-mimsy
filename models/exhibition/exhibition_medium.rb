class ExhibitionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :ekey, :mediakey, :eikey

  ignore_columns :step, :record_view, :eikey, :object, :relationship, :begin_date, :end_date, :note

  custom_attribute :exhibition_id, :ekey
  custom_attribute :medium_id, :mediakey
  custom_attribute :exhibition_catalog_id, :eikey
  custom_attribute :sort, :step

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :medium, foreign_key: "mediakey"
end