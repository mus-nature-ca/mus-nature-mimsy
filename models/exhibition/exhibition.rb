class Exhibition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions

  # specify primary key name
  self.primary_key = :ekey

  # override decimal set
  set_integer_columns :ekey, :pexh_id, :record_view

  ignore_columns :step, :record_view, :curated_by, :designed_by, 
    :sponsors, :visitor_count, :catalogue, :pkey, :external_file, 
    :note, :option1, :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :ekey
  custom_attribute :publication_id, :pkey

  has_many :catalogs, through: :exhibition_catalogs, source: :catalog
  has_many :exhibition_catalogs, foreign_key: "ekey"

  has_many :loans, through: :exhibition_loans, source: :loan
  has_many :exhibition_loans, foreign_key: "ekey"

  has_many :locations, through: :exhibition_locations, source: :location
  has_many :exhibition_locations, foreign_key: "ekey"

  has_many :media, through: :exhibition_media, source: :medium
  has_many :exhibition_media, foreign_key: "ekey"

  has_many :themes, class_name: "ExhibitionTheme", foreign_key: "ekey"
  has_many :venues, class_name: "ExhibitionVenue", foreign_key: "ekey"
end