#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/edlund.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CMN Catalogue Number"]

  obj = Catalog.find_by_catalog_number(row["CMN Catalogue Number"])
  obj.place_collected = row["Place Collected (to import)"]
  obj.save

  cp = obj.catalog_collection_places
  cp.destroy_all

  cp = CatalogCollectionPlace.new
  cp.catalog_id = obj.id
  cp.place_id = row["New Placekey"].to_i
  cp.save
end