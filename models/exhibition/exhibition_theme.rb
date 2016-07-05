class ExhibitionTheme < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibition_themes

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :ekey

  custom_attribute :exhibition_id, :ekey

  belongs_to :exhibition, foreign_key: "ekey"
end