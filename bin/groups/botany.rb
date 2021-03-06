#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

groups = Group.where(group_owner: ["BOTDATA1", "VISITOR"])

CSV.open(output_dir(__FILE__) + "/BOTDATA1-VISITOR-groups.csv", 'w') do |csv|
  csv << Group.custom_attribute_names
  groups.find_each do |group|
    csv << group.custom_attributes.values
  end
end