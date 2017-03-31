#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-update-objects-utf16.txt"

acquisition_number = "A2017.0088"
home_location = "Room C1460 ; CASES Project ; Main collection"

acquisition = Acquisition.find_by_acquisition_number(acquisition_number)

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  catalog_number = row["CATALOGUE.ID_NUMBER"].strip
  catalog = Catalog.find_by_catalog_number(catalog_number)
  catalog.acquisition_number = acquisition_number
  catalog.home_location = home_location
  catalog.save

  cat_aq = AcquisitionCatalog.new
  cat_aq.catalog_id = catalog.id
  cat_aq.acquisition_id = acquisition.id
  cat_aq.id_number = catalog_number
  cat_aq.save
  
  puts row["CATALOGUE.ID_NUMBER"]
end