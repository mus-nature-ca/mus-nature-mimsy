class SiteCoordinate < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_coordinates

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :skey
  set_string_columns :direction

  custom_attribute :site_id, :skey
  custom_attribute :type, :coord_type
  custom_attribute :degrees, :part1
  custom_attribute :minutes, :part2
  custom_attribute :seconds, :part3
  custom_attribute :decimal_degrees, :decimal_coordinate

  belongs_to :site, foreign_key: "skey"
end