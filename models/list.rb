class List < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :lists

  # specify primary key name
  self.primary_key = :list_key

  # override decimal set
  set_integer_columns :list_key, :view_value

  def self.all_terms
    values = {}
    pluck(:field).uniq.compact.each do |f|
      if f == "TAXON LEVEL TEXT"
        values[f] = List.where(field: f).map(&:term3).uniq.compact.sort_by(&:downcase)
      else
        values[f] = List.where(field: f).map(&:term1).uniq.compact.sort_by(&:downcase)
      end
    end
    values
  end
end