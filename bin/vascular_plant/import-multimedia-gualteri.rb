#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Media 2017-10-iv.txt"
log = "/Users/dshorthouse/Desktop/Media 2017-10-iv-log.csv"

missing = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  next if row["MEDIA.MEDIA_ID"].nil?

  puts row["MEDIA.MEDIA_ID"]

  #Get the linked object
  catalog = Catalog.find_by_catalog_number(row["MEDIA_ITEMS.OBJECT"].strip)

  if catalog.nil?
    missing << [row["MEDIA.MEDIA_ID"], "#{row["MEDIA_ITEMS.OBJECT"]} catalog missing"]
  else

    #check if image exists
    path = row["MEDIA.LOCATOR"].gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
    if !File.exists?(File.join(path, row["MEDIA.MEDIA_ID"]))
      missing << [row["MEDIA.MEDIA_ID"], "image missing"]
    end

    #check if multimedia item already exists
    item = Medium.find_by_media_id(row["MEDIA.MEDIA_ID"])

    if !item.nil?
      missing << [row["MEDIA.MEDIA_ID"], "duplicate"]
    else
      #Save new media record
      m = Medium.new
      m.media_id = row["MEDIA.MEDIA_ID"].strip
      m.locator = row["MEDIA.LOCATOR"].strip rescue nil
      m.record_type = row["MEDIA.RECORD_TYPE"].strip rescue nil
      m.media = row["MEDIA.MEDIA"].strip rescue nil
      m.format = row["MEDIA.FORMAT"].strip rescue nil
      m.thumbnail = (row["MEDIA.THUMBNAIL"].strip == "Y") ? true : false rescue nil
      m.date_captured = row["MEDIA.DATE_CAPTURED"].strip rescue nil
      m.capture_method = row["MEDIA.CAPTURE_METHOD"].strip rescue nil
      m.captured_by = row["MEDIA.CAPTURED_BY"].strip rescue nil
      m.media_type = row["MEDIA.MEDIA_TYPE"].strip rescue nil
      m.credit_line = row["MEDIA.CREDIT_LINE"].strip rescue nil
      m.caption = row["MEDIA.CAPTION"].strip rescue nil
      m.repro_allowed = (row["MEDIA.REPRO_ALLOWED"].strip == "Y") ? true : false rescue nil
      m.publish = (row["Publish"].strip == "Y") ? true : false rescue nil
      m.physical_location = row["MEDIA.PHYSICAL_LOCATION"].strip rescue nil
      m.location_date = row["MEDIA.LOCATION_DATE"].strip rescue nil
      m.save

      #reload Medium
      medium = Medium.find_by_media_id(m.media_id)

      #save new CatalogMedium record
      cm = CatalogMedium.new
      cm.medium_id = medium.id
      cm.catalog_id = catalog.id
      cm.sort = row["MEDIA_ITEMS.STEP"].strip rescue nil
      cm.save
    end

  end

end

CSV.open(log, 'w') do |csv|
  csv << ["Item", "Note"]
  missing.each do |item|
    csv << item
  end
end