class Loss < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loss

  # specify primary key name
  self.primary_key = :losskey

  # override decimal set
  set_integer_columns :losskey, :m_id

  belongs_to :catalog, primary_key: "losskey", foreign_key: "m_id"

  has_many :media, through: :loss_media, source: :medium
  has_many :loss_media, foreign_key: "losskey"
end