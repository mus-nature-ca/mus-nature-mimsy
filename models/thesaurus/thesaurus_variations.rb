class ThesaurusVariation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :thesaurus_variations

  # specify primary key name
  self.primary_key = :thesvarkey

  # override decimal set
  set_integer_columns :class_id
  
  belongs_to :thesaurus, foreign_key: "class_id"
end