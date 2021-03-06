class Damage < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :damage

  # specify primary key name
  self.primary_key = :dkey

  # override decimal set
  set_integer_columns :dkey, :m_id

  validates :m_id, presence: true

  custom_attribute :id, :dkey
  custom_attribute :catalog_id, :m_id

  belongs_to :catalog, primary_key: "m_id", foreign_key: "mkey"

  has_many :media, through: :damage_media, source: :medium
  has_many :damage_media, foreign_key: "dkey"
end