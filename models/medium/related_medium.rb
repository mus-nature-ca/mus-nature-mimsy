class RelatedMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :related_media

  # specify primary key name
  self.primary_key = :relreckey

  # override decimal set
  set_integer_columns :relreckey, :mediakey, :related_mediakey

  custom_attribute :medium_id, :mediakey
  custom_attribute :related_medium_id, :related_mediakey

  belongs_to :medium, primary_key: "related_mediakey", foreign_key: "mediakey"
end