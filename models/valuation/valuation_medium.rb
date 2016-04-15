# Table does not exist, but provided here because it is indicated in Tables_Links.pdf
class ValuationMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :valuation_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :trans_id, :mediakey

  belongs_to :valuation, foreign_key: "trans_id"
  belongs_to :media, foreign_key: "mediakey"
end