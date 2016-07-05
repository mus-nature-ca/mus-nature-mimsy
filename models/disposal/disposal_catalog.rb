class DisposalCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :disposal_items

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :akey, :m_id

  custom_attribute :disposal_id, :akey
  custom_attribute :catalog_id, :m_id
  custom_attribute :description, :item_summary

  belongs_to :disposal, foreign_key: "akey"
  belongs_to :catalog, foreign_key: "m_id"
end