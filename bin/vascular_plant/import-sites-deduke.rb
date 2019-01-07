#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Sites MXG Upload RTM Dec 2018 - Toronto BB.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["SITES.SITE_ID"]

  #create new site record
  site = Site.new
  site.site_id = row["SITES.SITE_ID"].strip
  site.site_name = row["SITES.SITE_NAME"].strip
  site.environment = row["SITES.SITE_CLASS"].strip rescue nil
  site.elevation = row["SITES.ELEVATION"].strip rescue nil
  site.vegetation = row["SITES.VEGETATION"].strip rescue nil
  site.site_date = row["SITES.SITE_DATE"].strip rescue nil
  site.description = row["SITES.DESCRIPTION"].strip rescue nil
  site.register_status = row["SITES.REGISTER_STATUS"].strip rescue nil
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.note = row["SITES.NOTE"] rescue nil
  site.recommendations = row["SITES.RECOMMENDATIONS"].strip rescue nil
  site.start_latitude_dec = row["SITES.START_LATITUDE_TXT"].strip rescue nil
  site.start_longitude_dec = row["SITES.START_LONGITUDE_TXT"].strip rescue nil
  site.location_accuracy = row["SITES.LOCATION_ACCURACY"].strip rescue nil
  site.archaeological_status = row["SITES.ARCHAEOLOGICAL_STATUS"].strip rescue nil
  site.geodetic_datum = row["SITES.GEODETIC_DATUM"].strip rescue nil
  site.georef_source = row["SITES.GEOREF_SOURCE"].strip rescue nil
  site.coord_uncertainty = row["SITES.COORD_UNCERTAINTY"].strip rescue nil
  site.publish = true

  site.save

  #query for created site - damn Oracle!
  site = Site.find_by_site_id(site.site_id)
  site.decimal_is_primary = row["SITES.DECIMAL_IS_PRIMARY"].strip rescue nil
  site.start_latitude = row["SITES.START_LATITUDE_TXT"].strip rescue nil
  site.start_longitude = row["SITES.START_LONGITUDE_TXT"].strip rescue nil
  site.save

end

