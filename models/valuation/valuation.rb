class Valuation < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :valuation

  # specify primary key name
  self.primary_key = :trans_id

  # override decimal set
  set_integer_columns :trans_id, :m_id

  ignore_columns :step, :record_view, :currency, :exchange_value, :exchange_rate, :exchange_currency, :last_valuation, :last_currency, :next_valuation_date, :option1, :option2, :number1, :number2, :date1, :date2

  custom_attribute :id, :trans_id
  custom_attribute :catalog_id, :m_id

  belongs_to :catalog, primary_key: "trans_id", foreign_key: "m_id"

  has_many :media, through: :valuation_media, source: :medium
  has_many :valuation_media, foreign_key: "trans_id"
end