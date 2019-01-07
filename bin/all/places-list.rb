#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

(0..13).each do |level|
  CSV.open(output_dir(__FILE__) + "/place-hierarchy-political-#{level}.csv", 'w') do |csv|
    Place.where(hierarchy_level: level).where(political_name: true).pluck(:name).compact.uniq.sort.each do |name|
      csv << [name]
    end
  end
  CSV.open(output_dir(__FILE__) + "/place-hierarchy-geographic-#{level}.csv", 'w') do |csv|
    Place.where(hierarchy_level: level).where(geographic_name: true).pluck(:name).compact.uniq.sort.each do |name|
      csv << [name]
    end
  end
end
