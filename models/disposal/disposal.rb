class Disposal < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposals

  # specify primary key name
  self.primary_key = :akey

  # override decimal set
  set_integer_columns :akey, :record_view

  ignore_columns :step, :record_view, :legal_date_display, :source, 
    :total_price, :currency, :exchange_rate, :rate_date, :terms, 
    :provisos, :option1, :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :akey
  custom_attribute :reference_number, :ref_number

  categorical :status, :method

  has_many :catalogs, through: :disposal_catalogs, source: :catalog
  has_many :disposal_catalogs, foreign_key: "akey"

  has_many :sources, through: :disposal_sources, source: :person
  has_many :disposal_sources, foreign_key: "akey"

  has_many :media, through: :disposal_media, source: :medium
  has_many :disposal_media, foreign_key: "akey"
end