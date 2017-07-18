class DisposalCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposal_items

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :akey, :m_id

  ignore_columns :step, :record_view, :offer_price, :price, 
    :price_currency, :price_exchange_rate, :price_rate_date, 
    :repro_order_number, :dispatch_number, :dispatched_to

  custom_attribute :disposal_id, :akey
  custom_attribute :catalog_id, :m_id
  custom_attribute :description, :item_summary
  custom_attribute :catalog_number, :id_number

  categorical :status, :disposal_method

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :catalog, foreign_key: "m_id"
end