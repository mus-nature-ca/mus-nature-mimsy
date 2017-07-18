#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalog_ids = CatalogSite.group(:mkey).having('count(*) > 1').count.keys

CSV.open(output_dir(__FILE__) + "/catalogs-many-sites.csv", 'w') do |csv|
  catalog_ids.each do |id|
    catalog = Catalog.find(id)
    csv << [catalog.collection, catalog.catalog_number]
  end
end