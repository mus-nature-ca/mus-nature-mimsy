class SiteSurvey < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :site_surveys

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :skey

  belongs_to :site, foreign_key: "skey"
end