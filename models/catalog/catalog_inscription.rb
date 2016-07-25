class CatalogInscription < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :inscriptions

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :mkey

  ignore_columns :step, :record_view, :inscription_method, 
    :inscription_location, :inscriber, :original_language, 
    :inscription_script, :translation, :transliteration, 
    :inscription_number, :description, :note

  custom_attribute :catalog_id, :mkey
  custom_attribute :type, :inscription_type
  custom_attribute :text, :inscription_text
  custom_attribute :method, :inscription_method
  custom_attribute :location, :inscription_location
  custom_attribute :script, :inscription_script
  custom_attribute :number, :inscription_number
  custom_attribute :language, :original_language

  categorical :inscription_type

  belongs_to :catalog, foreign_key: "mkey"
end