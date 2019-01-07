#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/duplicate-CAN-records.csv"

other_numbers = CatalogOtherNumber.where(on_type: "stamped CMN accession number")
                  .group(:other_number)
                  .count.map{ |k,v| k if v > 1 }.compact

CSV.open(file, 'w') do |csv|
  csv << ["STAMPED_CMN_ACCESSION_NUMBER", "CATALOG_NUMBERS"]
  other_numbers.each do |num|
    cats = CatalogOtherNumber.where(other_number: num).map{|o| o.catalog.catalog_number }.join(" | ")
    csv << [num, cats]
  end
end