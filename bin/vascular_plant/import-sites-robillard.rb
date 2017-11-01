#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/robillard_sites_test.txt"

def coord_convert_dd(input)
  coord = input
  (/(\d+) (\d+\s)?(\d+|\d+[,.]\d+)\s([NSEW])/).match(input) do |m|
    if m[2].nil?
      coord = m[1].to_f + m[3].to_f/60
    else
      coord = m[1].to_f + m[2].to_f/60 + m[3].to_f/3600
    end
    if m[4] == "S" || m[4] == "W"
      coord = -coord
    end
  end
  coord
end

def coord_convert_symbols(input)
  coord = input
  (/(\d+) (\d+\s)?(\d+|\d+[,.]\d+)\s([NSEW])/).match(input) do |m|
    deg = "#{m[1]}° "
    min = m[2].nil? ? "#{m[3]}' " : "#{m[2]}' "
    sec = m[2].nil? ? "" : "#{m[3]}\" "
    card = m[4]
    coord = deg+min+sec+card
  end
  coord
end

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

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

  site.recommendations = row["SITES.RECOMMENDATIONS"].strip rescue nil
  site.start_latitude = row["SITES.START_LATITUDE"].strip.gsub(/([NEWS])/, ' \1') rescue nil
  site.start_latitude_dec = row["SITES.START_LATITUDE"].strip.to_f rescue nil
  site.start_longitude = row["SITES.START_LONGITUDE"].strip.gsub(/([NEWS])/, ' \1') rescue nil
  site.start_longitude_dec = row["SITES.START_LONGITUDE"].strip.to_f rescue nil
  site.location_accuracy = row["SITES.LOCATION_ACCURACY"].strip rescue nil

  coord_is_ll = false

  orig_lat = site.start_latitude.dup if !site.start_latitude.nil?
  orig_lng = site.start_longitude.dup if !site.start_longitude.nil?

  if !site.start_latitude.nil? && (/[NEWS]/).match(site.start_latitude) 
    && !site.location_accuracy.nil? && site.location_accuracy.include?("secondary(LL)")
    site.start_latitude_dec = coord_convert_dd(site.start_latitude)
    site.start_longitude_dec = coord_convert_dd(site.start_longitude)
    coord_is_ll = true
  end

  if !site.start_latitude_dec.nil? && !site.start_longitude_dec.nil?
    site.decimal_is_primary = true
  end

  site.publish = true
  site.location = row["SITES.LOCATION"].strip rescue nil
  site.note = row["SITES.NOTE"] rescue nil

  byebug
  puts ""

  site.save

  #query for created site - damn Oracle!
  site = Site.find_by_site_id(site.site_id)

  #fix coordinate text

  if coord_is_ll
    site.start_latitude = coord_convert_symbols(orig_lat)
    site.start_longitude = coord_convert_symbols(orig_lng)
    site.save
    
    site.reload
    site.decimal_is_primary = false
    site.save
  end

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
    if !site.decimal_is_primary
      coord.decimal_is_primary = false
    end
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

