#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../../environment.rb'
include Sinatra::Mimsy::Helpers


CSV.open(output_dir(__FILE__) + "/Catalog.csv", 'w') do |csv|
  Catalog.pluck(:id, :collection, :catalog_number).each do |item|
    csv << item
  end
end

CSV.open(output_dir(__FILE__) + "/CatalogSite.csv", 'w') do |csv|
  CatalogSite.pluck(:catalog_id, :site_id).each do |item|
    csv << item
  end
end

CSV.open(output_dir(__FILE__) + "/Site.csv", 'w') do |csv|
  Site.pluck(:id, :start_latitude_dec, :start_longitude_dec).each do |item|
    next if item[1].nil? || item[2].nil?
    csv << item
  end
end