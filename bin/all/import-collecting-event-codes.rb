#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Inverts-Objects-For-CollectingEvents.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  catalog = Catalog.find_by_catalog_number(row["CatalogNumber"].strip)
  if !catalog.nil?
    catalog.option9 = row["CollectingEventCode"].strip
    catalog.save
  else
    puts row["CatalogNumber"].red
  end
end