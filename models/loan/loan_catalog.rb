class LoanCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_items

  # specify primary key name
  self.primary_key = :litmkey

  # override decimal set
  set_integer_columns :litmkey, :m_id, :lkey

  custom_attribute :id, :litmkey
  custom_attribute :loan_id, :lkey
  custom_attribute :catalog_id, :m_id
  custom_attribute :description, :item_summary
  custom_attribute :venues, :loan_item_venues
  custom_attribute :shipper, :loan_item_shipping
  custom_attribute :fees, :loan_item_fees

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :loan, foreign_key: "lkey"
end