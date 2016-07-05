class DamageMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :damage_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :dkey, :m_id, :mediakey

  custom_attribute :catalog_id, :m_id
  custom_attribute :damage_id, :dkey
  custom_attribute :medium_id, :mediakey
  custom_attribute :sort, :step

  belongs_to :damage, foreign_key: "dkey"
  belongs_to :medium, foreign_key: "mediakey"
end