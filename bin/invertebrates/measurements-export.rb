#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group_name = "CMN Spionidae in database_08-01-2019"
group = Group.find_by_name(group_name)

=begin
CSV.open(output_dir(__FILE__) + "/Spionidae_measurements.csv", 'w') do |csv|
  csv << ["catalog", "site_id", "site_name", "measurements", "measure_type", "measure_length", "length_unit"]
  group.members.each do |member|
    catalog = Catalog.find(member.table_key)
    site = catalog.sites.first
    site.measurements.find_each do |m|
      csv << [catalog.catalog_number, site.site_id, site.site_name, site[:measurements], m.measure_type, m.measure_length, m.length_unit]
    end
  end
end
=end

CSV.open(output_dir(__FILE__) + "/Spionidae_other_numbers.csv", 'w') do |csv|
  csv << ["catalog", "site_id", "site_name", "type", "other_number"]
  group.members.each do |member|
    catalog = Catalog.find(member.table_key)
    site = catalog.sites.first
    site.other_numbers.find_each do |o|
      csv << [catalog.catalog_number, site.site_id, site.site_name, o.site_othnum_type, o.other_number]
    end
  end
end