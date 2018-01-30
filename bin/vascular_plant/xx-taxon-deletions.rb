#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

speckeys = [
  1140119,
  1140118,
  1140117,
  1140116,
  1143787,
  1133653,
  1133651,
  1133625,
  1133646,
  1133645,
  1133645,
  1133612,
  1133616,
  1133610,
  1133455,
  1133677,
  1133532,
  1133567,
  1133581,
  1133585,
  1133597,
  1133595,
  1133603,
  1133600
]

children = []

speckeys.each do |id|
  taxon = Taxon.find(id) rescue nil
  next if taxon.nil?
  if taxon.scientific_name.include?("xx") && taxon.catalogs.count == 0 && taxon.children.count == 0
    taxon.destroy
  else
    children << [taxon.id, taxon.scientific_name, taxon.children.map(&:id), taxon.children.map(&:scientific_name)]
  end
end

CSV.open(output_dir(__FILE__) + "/xx-taxa-children.csv", 'w') do |csv|
  csv << ["Speckey", "Name", "Child_Speckeys", "Child_Names"]
  children.each do |child|
    csv << child
  end
end