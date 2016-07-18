class ExhibitionVenue < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :exhibition_venues

  # specify primary key name
  self.primary_key = :id

  # override decimal set
  set_integer_columns :id, :ekey, :link_id

  ignore_columns :step, :record_view, :nvarkey, :contact, 
    :address, :phone, :fax, :email, :status, :status_date, 
    :install_start, :install_end, :installed_by, 
    :deinstall_start, :deinstall_end, :deinstalled_by, 
    :note, :unlinked_value

  custom_attribute :exhibition_id, :ekey
  custom_attribute :installation_start, :install_start
  custom_attribute :installation_end, :install_end
  custom_attribute :person_id, :link_id

  belongs_to :exhibition, foreign_key: "ekey"
end