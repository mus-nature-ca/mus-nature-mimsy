#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Site descriptions.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  place_name = row["SITES.DESCRIPTION"]
  next if !place_name
  candidates = Place.where(name: place_name.strip)
  if candidates.count == 0
    puts place_name.red
  elsif candidates.count == 1
    puts candidates.first.placekey.to_s.green
  elsif candidates.count > 1
    puts place_name.yellow
  end
end