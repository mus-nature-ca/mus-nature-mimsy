#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/MIMSY Sites-Candidate Places.txt"

counter = 0
CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  counter += 1
  site = Site.find(row["skey"])
  place = Place.find(row["placekey"])
  ps = PlaceSite.new
  ps.site_id = site.id
  ps.place_id = place.id
  ps.save
  puts counter
end