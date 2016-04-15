class DisposalSource < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "disposal_sources"

  # specify primary key name
  self.primary_key = "id"

  # override decimal set
  set_integer_columns :akey, :link_id

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :person, foreign_key: "link_id"
end