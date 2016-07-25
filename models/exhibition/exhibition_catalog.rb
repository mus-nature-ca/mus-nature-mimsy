class ExhibitionCatalog < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibition_items

  # specify primary key name
  self.primary_key = :eikey

  # override decimal set
  set_integer_columns :eikey, :ekey, :m_id

  ignore_columns :step, :record_view, :theme_sub4, :theme_sub5, 
    :theme_sub6, :level1, :level2, :level3, :level4, :level5, 
    :level6, :container, :arrangement, :catalogue_number, 
    :note, :option1, :option2, :option3, :option4, :number1, 
    :number2, :date1, :date2

  custom_attribute :id, :eikey
  custom_attribute :exhibition_id, :ekey
  custom_attribute :catalog_id, :m_id
  custom_attribute :type, :record_type
  custom_attribute :description, :item_summary

  categorical :type, :status

  belongs_to :exhibition, foreign_key: "ekey"
  belongs_to :catalog, foreign_key: "m_id"
end