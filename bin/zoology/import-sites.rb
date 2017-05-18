#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/MXG_Upload_LeSage_2016_Bufonidae_ST_sites_utf16.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  #create new site record
  site = Site.new
  site.site_id = row["SITE_ID"].strip
  site.site_name = row["SITE_NAME"].strip
  site.environment = row["SITE_CLASS"].strip rescue nil
  site.site_type = row["SITE_TYPE"].strip rescue nil
  site.description = row["DESCRIPTION"].strip rescue nil
  site.location_accuracy = row["LOCATION_ACCURACY"].strip rescue nil
  site.decimal_is_primary = true
  site.start_latitude_dec = row["START_LATITUDE_DEC"].strip.to_f rescue nil
  site.start_longitude_dec = row["START_LONGITUDE_DEC"].strip.to_f rescue nil
  site.georef_source = row["SITES.GEOREF_SOURCE"].strip rescue nil
  site.georef_status = row["SITES.GEOREF_STATUS"].strip rescue nil
  site.site_date = row["SITES.SITE_DATE"].strip rescue nil
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.publish = true
  site.save

  #query for created site - damn Oracle!
  site = Site.find_by_site_id(site.site_id)

  #fix coordinate text
  if !site.start_latitude.nil? || !site.start_longitude.nil?
    if !site.start_latitude.nil?
      site.start_latitude.gsub!(",", ".")
    end
    if !site.start_longitude.nil?
      site.start_longitude.gsub!(",", ".")
    end
    site.save
  end

  site.coordinates.each do |coord|
    coord.coord_type.downcase!
    coord.save
  end

  puts site.site_id

end

