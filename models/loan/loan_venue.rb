class LoanVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :loan_venues

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :lkey, :link_id, :nvarkey

  ignore_columns :step, :record_view, :nvarkey, :address, 
    :phone, :fax, :email, :status, :status_date, :date_visited, 
    :checkin_by, :condition_in, :courier_in, :courier_in_date, 
    :checkout_by, :condition_out, :courier_out, 
    :courier_out_date, :note, :unlinked_value

  custom_attribute :loan_id, :lkey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  belongs_to :loan, foreign_key: "lkey"
  belongs_to :person, foreign_key: "link_id"
end