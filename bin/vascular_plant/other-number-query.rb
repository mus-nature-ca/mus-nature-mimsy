#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

input = "/Users/dshorthouse/Desktop/VI barcode query.txt"
output = "/Users/dshorthouse/Desktop/VI barcode query-result.txt"

CSV.open(output, 'w') do |csv|
  csv << ["sort", "", "Collectors [string]", "Collection no.", "CAN barcode", "CAN accession", "CAN 2 barcode", "CAN 2 acces."]
  CSV.foreach(input, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
    catalog_number = row["CAN accession"]
    barcode = Catalog.find_by_catalog_number(catalog_number).catalog_number rescue nil
    if barcode.nil?
      other_number = CatalogOtherNumber.where({other_number: catalog_number, on_type: "stamped CMN accession number"})
      if other_number.size > 0
        barcode = other_number.first.catalog.catalog_number
      end
    end
    csv << [row["sort"], row[1], row["Collectors [string]"], row["Collection no."], barcode, row["CAN accession"], row["CAN 2 barcode"], row["CAN 2 acces."]]
  end
end