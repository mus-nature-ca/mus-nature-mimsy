class DisposalMedium < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposals_media

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :akey, :mediakey

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :medium, foreign_key: "mediakey"
end