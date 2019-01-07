#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Media upload_TIF_2017-05-11.txt"
log = "/Users/dshorthouse/Desktop/Media upload_TIF_2017-05-11-log.csv"

def add_image(row, catalog)
  #Save new media record
  m = Medium.new
  m.media_id = row[:media_id].strip
  m.locator = row[:locator].strip rescue nil
  m.record_type = row[:record_type].strip rescue nil
  m.media = row[:media].strip rescue nil
  m.format = row[:format].strip rescue nil
  m.thumbnail = (row[:thumbnail].strip == "Y") ? true : false rescue nil
  m.date_captured = row[:date_captured].strip rescue nil
  m.capture_method = row[:capture_method].strip rescue nil
  m.captured_by = row[:captured_by].strip rescue nil
  m.media_type = row[:media_type].strip rescue nil
  m.credit_line = row[:credit_line].strip rescue nil
  m.caption = row[:caption].strip rescue nil
  m.repro_allowed = (row[:repro_allowed].strip == "Y") ? true : false rescue nil
  m.publish = (row[:publish].strip == "Y") ? true : false rescue nil
  m.physical_location = row[:physical_location].strip rescue nil
  m.location_date = row[:location_date].strip rescue nil

  m.save

  #reload Medium
  medium = Medium.find_by_media_id(m.media_id)

  #save new CatalogMedium record
  cm = CatalogMedium.new
  cm.medium_id = medium.id
  cm.catalog_id = catalog.id
  cm.sort = row[:step].strip rescue nil
  cm.save
end

CSV.open(log, 'w') do |csv|
  csv << ["Item", "Note"]

  CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

    next if row["MEDIA.MEDIA_ID"].nil?

    puts row["MEDIA.MEDIA_ID"]

    catalog_number = row["MEDIA_ITEMS.OBJECT"].strip

    #Get the linked object
    catalog = Catalog.find_by_catalog_number(catalog_number)

    #check other number
    if catalog.nil?
      catalog = CatalogOtherNumber.where(other_number: catalog_number, on_type: "stamped CMN accession number").first.catalog rescue nil
    end

    if catalog.nil?
      csv << [row["MEDIA.MEDIA_ID"], "#{row["MEDIA_ITEMS.OBJECT"]} catalog missing as written or as a stamped CMN accession number"]
    else

      item = Medium.find_by_media_id(row["MEDIA.MEDIA_ID"])
      if !item.nil?
        csv << [row["MEDIA.MEDIA_ID"], "duplicate"]
      else
        data = {
          media_id: row["MEDIA.MEDIA_ID"],
          locator: row["MEDIA.LOCATOR"],
          record_type: row["MEDIA.RECORD_TYPE"],
          media: row["MEDIA.MEDIA"],
          format: row["MEDIA.FORMAT"],
          thumbnail: row["MEDIA.THUMBNAIL"],
          date_captured: row["MEDIA.DATE_CAPTURED"],
          capture_method: row["MEDIA.CAPTURE_METHOD"],
          captured_by: row["MEDIA.CAPTURED_BY"],
          media_type: row["MEDIA.MEDIA_TYPE"],
          credit_line: row["MEDIA.CREDIT_LINE"],
          caption: row["MEDIA.CAPTION"],
          repro_allowed: row["MEDIA.REPRO_ALLOWED"],
          publish: row["MEDIA.PUBLISH"],
          physical_location: row["MEDIA.PHYSICAL_LOCATION"],
          location_date: row["MEDIA.LOCATION_DATE"],
          step: row["MEDIA_ITEMS.STEP"]
        }
        add_image(data, catalog)
      end

    end

  end

end