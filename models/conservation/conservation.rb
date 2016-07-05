class Conservation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :conservation

  # specify primary key name
  self.primary_key = :conskey

  # override decimal set
  set_integer_columns :conskey, :m_id

  validates :m_id, presence: true

  custom_attribute :id, :conskey
  custom_attribute :catalog_id, :m_id
  custom_attribute :conservator, :performed_by

  belongs_to :catalog, primary_key: "m_id", foreign_key: "mkey"
  
  has_many :details, class_name: "ConservationDetail", foreign_key: "conskey"
  has_many :fees, class_name: "ConservationFee", foreign_key: "conskey"

  has_many :media, through: :conservation_media, source: :medium
  has_many :conservation_media, foreign_key: "conskey"

  has_many :conditions, through: :condition_conservations, source: :condition
  has_many :condition_conservations, foreign_key: "conskey"
end