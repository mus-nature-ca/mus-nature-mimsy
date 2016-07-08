class DisposalSource < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposal_sources

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :akey, :link_id, :nvarkey

  ignore_columns :step, :record_view, :phone, :fax, :email, :funding_amount

  custom_attribute :disposal_id, :akey
  custom_attribute :person_id, :link_id
  custom_attribute :person_variation_id, :nvarkey

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :person, foreign_key: "link_id"
end