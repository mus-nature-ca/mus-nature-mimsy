class LossMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loss_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :losskey, :mediakey

  custom_attribute :loss_id, :losskey
  custom_attribute :medium_id, :mediakey

  belongs_to :loss, foreign_key: "losskey"
  belongs_to :media, foreign_key: "mediakey"
end