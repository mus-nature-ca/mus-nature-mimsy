class Acquisition < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisitions

  # specify primary key name
  self.primary_key = :akey

  # override decimal set
  set_integer_columns :akey, :record_view

  ignore_columns :step, :record_view, :source, :description, 
    :return_instructions, :credit_line, :accession_number, 
    :exchange_rate, :rate_date, :funding_amount, :accruals, 
    :option2, :number1, :number2, :date1, :date2

  # custom attribute
  custom_attribute :id, :akey
  custom_attribute :acquisition_number, :ref_number
  custom_attribute :collection, :option1

  categorical :status, :method, :currency

  has_many :catalogs, through: :acquisition_catalogs, source: :catalog
  has_many :acquisition_catalogs, foreign_key: "akey"

  has_many :sources, through: :acquisition_sources, source: :person
  has_many :acquisition_sources, foreign_key: "akey"

  has_many :media, through: :acquisition_media, source: :medium
  has_many :acquisition_media, foreign_key: "akey"
end