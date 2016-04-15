class Condition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "condition"

  # specify primary key name
  self.primary_key = "condkey"

  # override decimal set
  set_integer_columns :condkey

  belongs_to :catalog, primary_key: "condkey", foreign_key: "m_id"

  has_many :media, through: :condition_media, source: :medium
  has_many :condition_media, foreign_key: "condkey"
end