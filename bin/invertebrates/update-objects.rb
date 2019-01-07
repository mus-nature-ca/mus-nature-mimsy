#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/A2018.0109 Brodo Import Template 2018.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  puts row["CATALOGUE.ID_NUMBER"]
  obj = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"].strip)
  #other numbers
  (1..5).each do |num|
    number = row["OTHER_NUMBERS.OTHER_NUMBER#{num}"].strip rescue nil
    if !number.nil?
      other_number = CatalogOtherNumber.new
      other_number.catalog_id = obj.id
      other_number.other_number = number
      other_number.on_type = row["OTHER_NUMBERS.ON_TYPE#{num}"].strip rescue nil
      other_number.save
    end
  end
end
