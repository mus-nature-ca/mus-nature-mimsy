#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/parasite_multiple_places.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  site = Site.find_by_site_id(row["site_id"].strip)
  site.catalogs.each do |catalog|

    if catalog.catalog_collection_places.count == 1 && 
       catalog.catalog_collection_places.first.placekey != row["placekey"].to_i
       place = catalog.catalog_collection_places.first
       place.placekey = row["placekey"].to_i
       place.save
       place.reload
       catalog.place_collected = place["place"]
       catalog.save
    end

  end

end