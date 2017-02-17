#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-sites.csv"

CSV.foreach(file, :headers => true) do |row|
  #create new site record
  site = Site.new
  site.site_id = row["SITES.SITE_ID"].strip
  site.site_name = row["SITES.SITE_NAME"].strip
  site.site_date = row["SITES.SITE_DATE"].strip
  site.description = row["SITES.SITE_DESCRIPTION"].strip
  site.register_status = row["SITES.REGISTER_STATUS"].strip
  site.start_latitude = row["SITES.START_LATITUDE"].strip
  site.start_latitude_dec = row["SITES.START_LATITUDE"].strip
  site.start_longitude = row["SITES.START_LONGITUDE"].strip
  site.start_longitude_dec = row["SITES.START_LONGITUDE"].strip
  site.save

  #query for created site - damn Oracle!
  site = Site.find_by_site_id(site.site_id)

  #create site coordinates
  ["latitude", "longitude"].each do |type|
    site_coordinate = SiteCoordinate.new
    site_coordinate.site_id = site.id
    site_coordinate.coord_type = "start #{type}"
    site_coordinate.decimal_coordinate = site.send("start_#{type}_dec")
    site_coordinate.decimal_is_primary = true
    site_coordinate.save
  end

  #create other numbers
  other_number = SiteOtherNumber.new
  other_number.site_id = site.id
  other_number.other_number = row["SITE_OTHER_NUMBERS.OTHER_NUMBER"].strip
  other_number.save

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

