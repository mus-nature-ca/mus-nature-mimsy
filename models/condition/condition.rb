class Condition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :condition

  # specify primary key name
  self.primary_key = :condkey

  # override decimal set
  set_integer_columns :condkey, :m_id

  validates :m_id, presence: true

  custom_attribute :id, :condkey
  custom_attribute :catalog_id, :m_id

  belongs_to :catalog, primary_key: "condkey", foreign_key: "m_id"

  has_many :media, through: :condition_media, source: :medium
  has_many :condition_media, foreign_key: "condkey"

  has_many :conservations, through: :condition_conservations, source: :conservation
  has_many :condition_conservations, foreign_key: "condkey"
end