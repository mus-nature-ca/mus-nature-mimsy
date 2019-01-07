#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/!MXG Upload Sokoloff 2018.09b Object Update.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CATALOGUE.ID_NUMBER"]

  #updates existing record
  obj = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"].strip)
  obj.materials = row["CATALOGUE.MATERIALS"].strip rescue nil
  obj.description = row["CATALOGUE.DESCRIPTION"].strip rescue nil
  obj.note = row["CATALOGUE.NOTE"].strip rescue nil
  obj.save

end

