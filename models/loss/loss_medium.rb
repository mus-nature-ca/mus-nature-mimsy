class LossMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loss_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :losskey, :mediakey, :m_id

  custom_attribute :catalog_id, :m_id
  custom_attribute :loss_id, :losskey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step

  belongs_to :loss, foreign_key: "losskey"
  belongs_to :medium, foreign_key: "mediakey"
end