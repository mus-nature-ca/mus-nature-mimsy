class Medium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :media

  # specify primary key name
  self.primary_key = :mediakey

  # override decimal set
  set_integer_columns :mmed_id, :mediakey, :primary, :record_view

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

  has_many :descriptors, class_name: "MediumDescrioptor", foreign_key: "mediakey"

  has_many :events, through: :medium_events, source: :event
  has_many :medium_events, foreign_key: "mediakey"

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

  has_many :people, through: :medium_people, source: :person
  has_many :medium_people, foreign_key: "mediakey"

  has_many :places, through: :medium_places, source: :place
  has_many :medium_places, foreign_key: "mediakey"

  has_many :publications, through: :medium_publications, source: :publication
  has_many :medium_publications, foreign_key: "mediakey"

  has_many :related_media, foreign_key: "mediakey", dependent: :destroy

  has_many :sites, through: :site_media, source: :site
  has_many :site_media, foreign_key: "mediakey"

  has_many :taxa, through: :medium_taxa, source: :taxon
  has_many :medium_taxa, foreign_key: "mediakey"

  def related
    related_media
  end

end