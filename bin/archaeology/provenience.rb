#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/ProvenienceGroup.csv"

CSV.foreach(file, :headers => true, :col_sep => ",", :encoding => 'bom|utf-16le:utf-8') do |row|
  catalog_number = row["Borden Catalogue Number"]
  group = row["Provenience Group"]
  catalog = Catalog.find_by_catalog_number(catalog_number)
  catalog.option8 = group
  catalog.save
end