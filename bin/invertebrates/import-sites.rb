#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-sites.csv"

CSV.foreach(file, :headers => true) do |row|

  #create new site record
  site = Site.new
  site.site_id = row["SITES.SITE_ID"]
  site.site_name = row["SITES.SITE_NAME"]
  site.site_date = row["SITES.SITE_DATE"]
  site.description = row["SITES.SITE_DESCRIPTION"]
  site.register_status = row["SITES.REGISTER_STATUS"]
  site.start_latitude = row["SITES.START_LATITUDE"]
  site.start_latitude_dec = row["SITES.START_LATITUDE"]
  site.start_longitude = row["SITES.START_LONGITUDE"]
  site.start_longitude_dec = row["SITES.START_LONGITUDE"]
  site.save

  #query for created site - damn Oracle!
  id = Site.find_by_site_id(site.site_id)

  #create site coordinates
  ["latitude", "longitude"].each do |type|
    site_coordinate = SiteCoordinate.new
    site_coordinate.site_id = id
    site_coordinate.coord_type = "start #{type}"
    site_coordinate.decimal_coordinate = site.send("start_#{type}_dec")
    site_coordinate.decimal_is_primary = true
    site_coordinate.save
  end

  #create other numbers
  other_number = SiteOtherNumber.new
  other_number.site_id = id
  other_number.other_number = row["SITE_OTHER_NUMBERS.OTHER_NUMBER"]
  other_number.save

  #create measurements
  (1..12).each do |m|
    type = row["SITE_MEASUREMENTS.MEASURE_TYPE_#{m}"] rescue nil
    if !type.nil? && !type.empty?
      measurement = SiteMeasurement.new
      measurement.site_id = id
      measurement.measure_type = type
      measurement.measure_length = row["SITE_MEASUREMENTS.MEASURE_LENGTH_#{m}"]
      measurement.length_unit = row["SITE_MEASUREMENTS.LENGTH_UNIT_#{m}"]
      measurement.save
    end
  end

end

