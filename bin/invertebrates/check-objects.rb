#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/LeSage-existing-objects.txt"

CSV.foreach(file, :headers => false, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  obj = Catalog.find_by_catalog_number(row)
  obj.destroy
end