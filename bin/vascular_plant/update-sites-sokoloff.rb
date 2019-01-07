#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/!MXG Upload Sokoloff 2018.09b Site Update.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["SITES.SITE_ID"]

  #updates existing record
  site = Site.find_by_site_id(row["SITES.SITE_ID"].strip)
  site.note = row["SITES.NOTE"] rescue nil
  site.archaeological_status = row["SITES.ARCHAEOLOGICAL_STATUS"].strip rescue nil
  site.site_date = row["SITES.SITE_DATE"].strip rescue nil
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.location_accuracy = row["SITES.LOCATION_ACCURACY"].strip rescue nil
  site.geodetic_datum = row["SITES.GEODETIC_DATUM"].strip rescue nil
  site.georef_source = row["SITES.GEOREF_SOURCE"].strip rescue nil
  site.coord_uncertainty = row["SITES.COORD_UNCERTAINTY"].strip rescue nil
  site.uncertainty_unit = row["SITES.UNCERTAINTY_UNIT"].strip rescue nil
  site.save

end

