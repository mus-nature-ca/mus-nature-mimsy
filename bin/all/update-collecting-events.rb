#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/palaeo_collecting_events2.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  puts row["CatalogNumber"].strip
  catalog = Catalog.find_by_catalog_number(row["CatalogNumber"].strip)
  catalog.collecting_event_code = row["Collecting Events"].strip
  catalog.save
end