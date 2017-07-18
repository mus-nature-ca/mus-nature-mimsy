# Table does not exist, but provided here because it is indicated in Tables_Links.pdf
class ValuationMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :valuation_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :trans_id, :mediakey

  custom_attribute :valuation_id, :trans_id
  custom_attribute :medium_id, :mediakey
  custom_attribute :catalog_id, :m_id

  belongs_to :valuation, foreign_key: "trans_id"
  belongs_to :medium, foreign_key: "mediakey"
end