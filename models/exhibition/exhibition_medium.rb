class ExhibitionMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibitions_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :ekey, :mediakey

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :media, foreign_key: "mediakey"
end