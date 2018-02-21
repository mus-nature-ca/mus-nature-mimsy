#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Inverts-import_Reference_collection.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CATALOGUE.ID_NUMBER"]
  obj = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"])
  if obj.nil?
    puts row["CATALOGUE.ID_NUMBER"] + " is missing"
    next
  end

  #update catalog record
  obj.note = row["CATALOGUE.NOTE"].strip rescue nil
  obj.home_location = row["CATALOGUE.HOME_LOCATION"].strip rescue nil
  obj.publish = true
  obj.save

end