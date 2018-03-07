#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Objects_Resolute_Mollusca_Reference Collection.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  catalog = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"])
  other_numbers = CatalogOtherNumber.where(catalog_id: catalog.id)

  if other_numbers.count == 1 && other_numbers.first.on_type.nil?
    num = other_numbers.first
    if num.on_type.nil?
      num.on_type = row["OTHER_NUMBERS.ON_TYPE"].strip rescue nil
      num.save
      puts catalog.catalog_number
    end
  end

end

