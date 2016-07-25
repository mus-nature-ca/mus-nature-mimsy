class Loan < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loans

  # specify primary key name
  self.primary_key = :lkey

  # override decimal set
  set_integer_columns :lkey, :record_view, :link_id, :nvarkey

  ignore_columns :step, :record_view, :contact2, :address2, 
    :phone2, :fax2, :email2, :loan_fee, :est_total_cost, 
    :act_total_cost, :assessment, :option2, :number1, 
    :number2, :date2

  custom_attribute :id, :lkey
  custom_attribute :institution, :name
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  categorical :direction, :status, :purpose

  has_one :person, class_name: "Person", primary_key: "link_id", foreign_key: "link_id"

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
    venues.map(&:preferred_name)
  end

  def contacts
    loan_venues.map(&:contact)
  end
end