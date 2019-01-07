#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/import_catalog_name_check.txt"
log = "/Users/dshorthouse/Desktop/import_catalog_name_check-log.csv"

different = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  name = row["ITEM_NAME"].strip
  catalog_number = row["ID_NUMBER"].strip

  match = catalog_number.match(/([A-Z]{3})([0-9]{1,}$)/)

  if match
    catalog_number = [match[1], match[2]].join(" ")
  end

  begin
    catalog = Catalog.find_by_catalog_number(catalog_number)
    note = nil
    if catalog.scientific_name != name
      attached_name = catalog.taxa.first.scientific_name
      if attached_name != name
        note = "different attached taxon"
      end
      different << [catalog_number, name, catalog.scientific_name, attached_name, note]
    end
  rescue
    different << [catalog_number, name, nil, nil, "no attached taxon"]
  end
end

CSV.open(log, 'w') do |csv|
  csv << ["ID_NUMBER", "ITEM_NAME", "ACTUAL_ITEM_NAME", "ATTACHED_NAME", "NOTE"]
  different.each do |item|
    csv << item
  end
end