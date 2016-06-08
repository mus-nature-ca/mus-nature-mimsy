class CollectedDate < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :date_collected

  # specify primary key name
  self.primary_key = :timekey

  # override decimal set
  set_integer_columns :mkey, :timekey

  custom_attribute :catalog_id, :mkey
  custom_attribute :context, :collection_position

  belongs_to :catalog, foreign_key: "mkey"
end