class Loan < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loans

  # specify primary key name
  self.primary_key = :lkey

  # override decimal set
  set_integer_columns :lkey

  has_many :catalogs, through: :loan_catalogs, source: :catalog
  has_many :loan_catalogs, foreign_key: "lkey"

  has_many :exhibitions, through: :exhibition_loans, source: :exhibition
  has_many :exhibition_loans, foreign_key: "lkey"

  has_many :locations, through: :loan_locations, source: :location
  has_many :loan_locations, foreign_key: "lkey"

  has_many :media, through: :loan_media, source: :medium
  has_many :loan_media, foreign_key: "lkey"

  has_many :venues, through: :loan_venues, source: :person
  has_many :loan_venues, foreign_key: "lkey"

  def institutions
    venues.map{ |v| v.preferred_name }
  end

  def contacts
    loan_venues.map{ |lv| lv.contact }
  end
end