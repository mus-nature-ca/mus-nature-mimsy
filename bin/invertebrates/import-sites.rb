#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-sites-utf16.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  #create new site record
  site = Site.new
  site.site_id = row["SITES.SITE_ID"].strip
  site.site_name = row["SITES.SITE_NAME"].strip
  site.site_date = row["SITES.SITE_DATE"].strip rescue nil
  site.description = row["SITES.DESCRIPTION"].strip rescue nil
  site.register_status = row["SITES.REGISTER_STATUS"].strip rescue nil
  site.decimal_is_primary = true
  site.start_latitude = row["SITES.START_LATITUDE"].strip.to_f rescue nil
  site.start_latitude_dec = row["SITES.START_LATITUDE"].strip.to_f rescue nil
  site.start_longitude = row["SITES.START_LONGITUDE"].strip.to_f rescue nil
  site.start_longitude_dec = row["SITES.START_LONGITUDE"].strip.to_f rescue nil
  site.environment = row["SITES.ENVIRONMENT"].strip rescue nil
  site.publish = true
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.location_accuracy = row["SITES.LOCATION_ACCURACY"].strip rescue nil
  site.note = row["SITES.NOTE"] rescue nil
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

  #create other numbers
  other_number = SiteOtherNumber.new
  other_number.site_id = site.id
  other_number.other_number = row["SITE_OTHER_NUMBERS.OTHER_NUMBER"].strip rescue nil
  if !other_number.other_number.nil?
    other_number.save
  end

  #create measurements
  (1..12).each do |m|
    type = row["SITE_MEASUREMENTS.MEASURE_TYPE_#{m}"].strip.downcase rescue nil
    if !type.nil?
      measurement = SiteMeasurement.new
      measurement.site_id = site.id
      measurement.measure_type = type
      measurement.measure_length = row["SITE_MEASUREMENTS.MEASURE_LENGTH_#{m}"].strip
      measurement.length_unit = row["SITE_MEASUREMENTS.LENGTH_UNIT_#{m}"].strip
      measurement.save
    end
  end

end

