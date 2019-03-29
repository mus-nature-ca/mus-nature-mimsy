#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

type = "stamped CMN accession number"

Catalog.where(collection: "Lichen").find_each do |catalog|
  puts catalog.catalog_number.green
  o = CatalogOtherNumber.new
  o.catalog_id = catalog.id
  o.other_number = catalog.catalog_number
  o.type = type
  o.save
end