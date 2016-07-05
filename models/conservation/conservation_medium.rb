class ConservationMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :conservation_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :conskey, :mediakey, :m_id

  custom_attribute :catalog_id, :m_id
  custom_attribute :conservation_id, :conskey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :conservation, foreign_key: "conskey"
  belongs_to :medium, foreign_key: "mediakey"
end