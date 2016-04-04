class Medium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "media"

  # specify primary key name
  self.primary_key = "mediakey"

  # override boolean set
  set_string_columns :orientation

  has_many :catalogs, through: :catalog_media, source: :catalog
  has_many :catalog_media, foreign_key: "mediakey"

  has_many :conditions, through: :condition_media, source: :condition
  has_many :condition_media, foreign_key: "mediakey"

  has_many :conservations, through: :conservation_media, source: :conservation
  has_many :conservation_media, foreign_key: "mediakey"

  has_many :damages, through: :damage_media, source: :damage
  has_many :damage_media, foreign_key: "mediakey"

  has_many :hazards, through: :hazard_media, source: :hazard
  has_many :hazard_media, foreign_key: "mediakey"

  has_many :losses, through: :loss_media, source: :loss
  has_many :loss_media, foreign_key: "mediakey"

  has_many :valuations, through: :valuation_media, source: :valuation
  has_many :valuation_media, foreign_key: "mediakey"

  has_many :acqusitions, through: :acquisition_media, source: :acquisition
  has_many :acquisition_media, foreign_key: "mediakey"

  has_many :disposals, through: :disposal_media, source: :disposal
  has_many :disposal_media, foreign_key: "mediakey"

  has_many :exhibitions, through: :exhibition_media, source: :exhibition
  has_many :exhibition_media, foreign_key: "mediakey"

  has_many :loans, through: :loan_media, source: :loan
  has_many :loan_media, foreign_key: "mediakey"
end