#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Downloads/asdfd.csv"

acquisition_number = "A2016.0008"
acquisition = Acquisition.find_by_acquisition_number(acquisition_number)

CSV.foreach(file, :headers => true) do |row|
  next if row["ID Number"].nil?
  catalog = Catalog.find_by_catalog_number(row["ID Number"])
  aq = AcquisitionCatalog.new
  aq.catalog_id = catalog.id
  aq.acquisition_id = acquisition.id
  aq.id_number = row["ID Number"]
  aq.save
end