class Group < ActiveRecord::Base
  # specify schema and table name
  self.table_name = :groups

  # specify primary key name
  self.primary_key = :group_id

  # override decimal set
  set_integer_columns :group_id, :link_type

  ignore_columns :step, :record_view

  custom_attribute :id, :group_id
  custom_attribute :name, :group_name
  custom_attribute :module, :link_type

  has_many :members, class_name: "GroupMember"

  def table
    case group_area
    when "catalogue"
      "Catalog"
    when "sites"
      "Site"
    when "taxonomy"
      "Taxon"
    when "publications"
      "Publication"
    when "events"
      "Event"
    when "media"
      "Medium"
    else
      nil
    end
  end

  def full_title
    "#{group_owner} - #{name}"
  end

end