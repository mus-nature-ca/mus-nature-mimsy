#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/batch 3 place updates to David (vasculars).txt"

problems = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  puts row["site_id"]

  site = Site.find_by_site_id(row["site_id"])
  catalog_ids = site.catalogs.map{|o| o.id if o.collection == row["collections"]}

  catalog_ids.each do |id|
    ccps = CatalogCollectionPlace.where({catalog_id: id})
    if ccps.count > 1
      problems << row["site_id"]
    else
      ccp = ccps.first
      if ccp.place_id != row["placekey"].to_i
        ccp.place_id = row["placekey"].to_i
        ccp.save
        ccp.reload

        catalog = Catalog.find(id)
        catalog.place_collected = ccp[:place]
        catalog.save
      end
    end
  end

end

byebug
puts ""
