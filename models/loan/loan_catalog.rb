class LoanCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_items

  # specify primary key name
  self.primary_key = :litmkey

  # override decimal set
  set_integer_columns :litmkey, :m_id, :lkey

  ignore_columns :step, :record_view, :crate_number, :insured_by, 
    :contact, :address, :phone, :fax, :email, :policy_number, 
    :insurance_value, :begin_insurance, :end_insurance, 
    :assessed_by, :assessment, :option1, :option2, :number1, 
    :number2, :date1, :date2

  custom_attribute :id, :litmkey
  custom_attribute :loan_id, :lkey
  custom_attribute :catalog_id, :m_id
  custom_attribute :description, :item_summary
  custom_attribute :venues, :loan_item_venues
  custom_attribute :shipper, :loan_item_shipping
  custom_attribute :fees, :loan_item_fees

  categorical :status

  belongs_to :catalog, foreign_key: "m_id"
  belongs_to :loan, foreign_key: "lkey"
end