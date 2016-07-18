class AcquisitionCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :acquisition_items

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :m_id, :akey

  ignore_columns :step, :record_view, :lotkey, 
    :lot_id, :assessment, :assessed_by, 
    :offer_price, :price, :price_currency, 
    :price_exchange_rate, :price_rate_date, 
    :initial_value, :value_currency, 
    :repro_order_number, :return_to, :option1, 
    :option2, :number1, :number2, :date1, :date2

  custom_attribute :catalog_id, :m_id
  custom_attribute :acquisition_id, :akey
  custom_attribute :description, :item_summary

  validates :id_number, presence: true

  belongs_to :acquisition, foreign_key: "akey"
  belongs_to :catalog, foreign_key: "m_id"
end