class ExhibitionTheme < ActiveRecord::Base
  # specify schema and table name
  self.table_name = "exhibition_themes"

  belongs_to :exhibition, foreign_key: "ekey"
end