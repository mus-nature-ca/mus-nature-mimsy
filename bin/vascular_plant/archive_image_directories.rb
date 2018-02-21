#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

log = "/Users/dshorthouse/Desktop/Archive_Images.csv"

REPLACE = {
  'CANA_' => 'CANA',
  'CANA-' => 'CANA',
  'CAN_' => 'CAN'
}

def output(file, locator)
  file_name = File.basename(file)
  puts file_name
  matches = file_name.gsub(/#{REPLACE.keys.join('|')}/, REPLACE).match(/^(CAN[ALM]{1}?)([0-9]{1,})/)
  catalog_number = "#{matches[1]} #{matches[2].to_i.to_s}" rescue nil

  if catalog_number
    catalog = Catalog.find_by_catalog_number(catalog_number)
    if catalog.nil?
      con = CatalogOtherNumber.where(other_number: catalog_number).where(on_type: "stamped CMN accession number")
      if con.size > 0
        catalog = con.first.catalog
        catalog_number = catalog.catalog_number
      end
    end
  end

  catalog_exists = catalog.nil? ? "N" : "Y"
  existing_image = Medium.find_by_media_id(file_name.sub(".tif", "") + ".jpg")
  date_captured = nil
  capture_method = nil
  captured_by = nil
  caption = nil
  if existing_image
    date_captured = existing_image.date_captured
    capture_method = existing_image.capture_method
    captured_by = existing_image.captured_by
    caption = existing_image.caption
  end
  [
    file_name,
    locator,
    "IMAGE",
    catalog_number,
    catalog_exists,
    nil,
    "digital image",
    "TIFF",
    nil,
    date_captured,
    capture_method,
    captured_by,
    "digital",
    "© Canadian Museum of Nature",
    caption,
    nil,
    nil,
    "Y",
    "Y"
  ]
end

CSV.open(log, 'w') do |csv|
  csv << [
    "MEDIA.MEDIA_ID",
    "MEDIA.LOCATOR",
    "MEDIA.RECORD_TYPE",
    "MEDIA_ITEMS.OBJECT",
    "CatalogExists",
    "MEDIA_ITEMS.STEP",
    "MEDIA.MEDIA",
    "MEDIA.FORMAT",
    "MEDIA.THUMBNAIL",
    "MEDIA.DATE_CAPTURED",
    "MEDIA.CAPTURE_METHOD",
    "MEDIA.CAPTURED_BY",
    "MEDIA.MEDIA_TYPE",
    "MEDIA.CREDIT_LINE",
    "MEDIA.CAPTION",
    "MEDIA.PHYSICAL_LOCATION",
    "MEDIA.LOCATION_DATE",
    "MEDIA.REPRO_ALLOWED",
    "MEDIA.PUBLISH"
  ]

  Dir.glob('/Volumes/botany/!!HERBARIUM PHOTO ARCHIVE/**/*.tif') do |file|
    locator = "\\\\n-nas1.mus-nature.ca\\botany\\Botany_Images_Archival\\" + File.dirname(file).sub("/Volumes/botany/","").gsub("/", "\\") + "\\"
    csv << output(file, locator)
  end

  Dir.glob('/Volumes/dept/BotanySpecimenImages/BotanyTempLocation/**/*.tif') do |file|
    locator = "\\\\n-nas1.mus-nature.ca\\" + File.dirname(file).sub("/Volumes/","").gsub("/", "\\") + "\\"
    csv << output(file, locator)
  end

end