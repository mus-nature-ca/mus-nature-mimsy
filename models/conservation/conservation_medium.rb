class ConservationMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :conservation_media

  # specify primary key name
  self.primary_keys = :conskey, :mediakey

  # override decimal set
  set_integer_columns :conskey, :mediakey

  belongs_to :conservation, foreign_key: "conskey"
  belongs_to :media, foreign_key: "mediakey"
end