#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Sites_ABS_FB, Hunter, Misc, Echinodermata series update.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["SITES.SITE_ID"]

  #create new site record
  site = Site.new
  site.site_id = row["SITES.SITE_ID"].strip
  site.site_name = row["SITES.SITE_NAME"].strip
  site.site_date = row["SITES.SITE_DATE"].strip rescue nil
  site.description = row["SITES.DESCRIPTION"].strip rescue nil
  site.register_status = row["SITES.REGISTER_STATUS"].strip rescue nil
  site.site_class = row["SITES.SITE_CLASS"].strip rescue nil
  site.site_type = row["SITES.SITE_TYPE"].strip rescue nil
  site.recommendations = row["SITES.RECOMMENDATIONS"].strip rescue nil
  site.start_latitude = row["SITES.START_LATITUDE"].strip.gsub(/([NEWS])/, ' \1') rescue nil
  site.start_latitude_dec = row["SITES.START_LATITUDE_DEC"].strip.to_f rescue nil
  site.start_longitude = row["SITES.START_LONGITUDE"].strip.gsub(/([NEWS])/, ' \1') rescue nil
  site.start_longitude_dec = row["SITES.START_LONGITUDE_DEC"].strip.to_f rescue nil
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.location_accuracy = row["SITES.LOCATION_ACCURACY"].strip rescue nil
  site.utm_start = row["SITES.UTM_START"] rescue nil
  site.elevation = row["SITES.ELEVATION"] rescue nil
  site.geodetic_datum = row["SITES.GEODETIC_DATUM"] rescue nil
  site.environment = row["SITES.ENVIRONMENT"].strip rescue nil
  site.note = row["SITES.NOTE"] rescue nil
  site.publish = true

  if site.location.nil? && row["PLACES.PLACEKEY"]
    hierarchy = Place.find(row["PLACES.PLACEKEY"]).location_hierarchy
    site.location = hierarchy
  end

  site.save

  #query for created site - damn Oracle!
  site = Site.find_by_site_id(site.site_id)
  site.decimal_is_primary = true

  #create other numbers
  (1..5).each do |num|
    o_number = row["SITE_OTHER_NUMBERS.OTHER_NUMBER_#{num}"].strip rescue nil
    if !o_number.nil?
      other_number = SiteOtherNumber.new
      other_number.site_id = site.id
      other_number.other_number = o_number
      other_number.type = row["SITE_OTHER_NUMBERS.SITE_OTHNUM_TYPE_#{num}"].strip rescue nil
      if !other_number.other_number.nil?
        other_number.save
      end
    end
  end

  #create measurements
  (1..22).each do |m|
    type = row["SITE_MEASUREMENTS.MEASURE_TYPE_#{m}"].strip rescue nil
    if !type.nil?
      measurement = SiteMeasurement.new
      measurement.site_id = site.id
      measurement.measure_type = type
      measurement.measure_length = row["SITE_MEASUREMENTS.MEASURE_LENGTH_#{m}"].strip rescue nil
      measurement.length_unit = row["SITE_MEASUREMENTS.LENGTH_UNIT_#{m}"].strip rescue nil
      measurement.save
    end
  end

end

