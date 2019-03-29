#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

log = "/Users/dshorthouse/Desktop/Object-Medium-link.csv"

CSV.open(log, 'w') do |csv|
  csv << ["ID Number", "Media ID"]
  Medium.includes(:catalog_media).where(items_media: { mediakey: nil }).find_each do |m|
    filename = m.media_id
    parts = filename.match(/^(CAN)([0-9]{1,})[axy]/)
    next if parts.nil?

    catalog_number = "#{parts[1]} #{parts[2]}"
    catalog = Catalog.find_by_catalog_number(catalog_number) rescue nil
    if catalog.nil?
      catalog = CatalogOtherNumber.where(other_number: catalog_number)
                                  .where(type: "stamped CMN accession number").first.catalog rescue nil
    end
    if !catalog.nil?
      cm = CatalogMedium.new
      cm.catalog_id = catalog.id
      cm.medium_id = m.id
      cm.save
      csv << [catalog_number, filename]
      puts filename.green
    end
  end
end

