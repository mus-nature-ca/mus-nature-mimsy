#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

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

#numbers = (9..10)
numbers = [1]

numbers.each do |num|

  padded = sprintf'%02d', num
  date = "2019-02-B#{padded}"
  file = "/Users/dshorthouse/Desktop/uploads/Media #{date}.txt"
  log = "/Users/dshorthouse/Desktop/uploads/Media #{date}-log.csv"

  missing = []

  CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

    next if row["MEDIA.MEDIA_ID_1"].nil?

    puts row["MEDIA.MEDIA_ID_1"]

    #Get the linked object
    catalog = Catalog.find_by_catalog_number(row["MEDIA_ITEMS.OBJECT"].strip)

    if catalog.nil?
      missing << [row["MEDIA.MEDIA_ID_1"], "#{row["MEDIA_ITEMS.OBJECT"]} catalog missing"]
    else

      #check if images exist
      path_1 = row["MEDIA.LOCATOR_1"].gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
      if !File.exists?(File.join(path_1, row["MEDIA.MEDIA_ID_1"]))
        missing << [row["MEDIA.MEDIA_ID_1"], "image missing"]
      end
      path_2 = row["MEDIA.LOCATOR_2"].gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
      if !File.exists?(File.join(path_2, row["MEDIA.MEDIA_ID_2"]))
        missing << [row["MEDIA.MEDIA_ID_2"], "image missing"]
      end

      #check if first of two item already exists
      item = Medium.find_by_media_id(row["MEDIA.MEDIA_ID_1"])
      if !item.nil?
        missing << [row["MEDIA.MEDIA_ID_1"], "duplicate"]
      else
        data = {
          media_id: row["MEDIA.MEDIA_ID_1"],
          locator: row["MEDIA.LOCATOR_1"],
          record_type: row["MEDIA.RECORD_TYPE"],
          media: row["MEDIA.MEDIA"],
          format: row["MEDIA.FORMAT_1"],
          thumbnail: row["MEDIA.THUMBNAIL_1"],
          date_captured: row["MEDIA.DATE_CAPTURED"],
          capture_method: row["MEDIA.CAPTURE_METHOD"],
          captured_by: row["MEDIA.CAPTURED_BY"],
          media_type: row["MEDIA.MEDIA_TYPE"],
          credit_line: row["MEDIA.CREDIT_LINE"],
          caption: row["MEDIA.CAPTION"],
          repro_allowed: row["MEDIA.REPRO_ALLOWED"],
          publish: row["Publish"],
          physical_location: row["MEDIA.PHYSICAL_LOCATION"],
          location_date: row["MEDIA.LOCATION_DATE"],
          step: row["MEDIA_ITEMS.STEP"]
        }
        add_image(data, catalog)
      end

      #check if second of two item already exists
      item = Medium.find_by_media_id(row["MEDIA.MEDIA_ID_2"])
      if !item.nil?
        missing << [row["MEDIA.MEDIA_ID_2"], "duplicate"]
      else
        data = {
          media_id: row["MEDIA.MEDIA_ID_2"],
          locator: row["MEDIA.LOCATOR_2"],
          record_type: row["MEDIA.RECORD_TYPE"],
          media: row["MEDIA.MEDIA"],
          format: row["MEDIA.FORMAT_2"],
          thumbnail: row["MEDIA.THUMBNAIL_2"],
          date_captured: row["MEDIA.DATE_CAPTURED"],
          capture_method: row["MEDIA.CAPTURE_METHOD"],
          captured_by: row["MEDIA.CAPTURED_BY"],
          media_type: row["MEDIA.MEDIA_TYPE"],
          credit_line: row["MEDIA.CREDIT_LINE"],
          caption: row["MEDIA.CAPTION"],
          repro_allowed: row["MEDIA.REPRO_ALLOWED"],
          publish: row["Publish"],
          physical_location: row["MEDIA.PHYSICAL_LOCATION"],
          location_date: row["MEDIA.LOCATION_DATE"],
          step: row["MEDIA_ITEMS.STEP"]
        }
        add_image(data, catalog)
      end

    end

  end

  CSV.open(log, 'w') do |csv|
    csv << ["Item", "Note"]
    missing.each do |item|
      csv << item
    end
  end

end