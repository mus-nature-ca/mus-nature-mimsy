class ExhibitionCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibition_items

  # specify primary key name
  self.primary_key = :eikey

  # override decimal set
  set_integer_columns :eikey, :ekey, :m_id

  custom_attribute :id, :eikey
  custom_attribute :exhibition_id, :ekey
  custom_attribute :catalog_id, :m_id
  custom_attribute :type, :record_type
  custom_attribute :description, :item_summary

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :catalog, foreign_key: "m_id"
end