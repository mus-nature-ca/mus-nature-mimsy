#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Hovingh- Batch upload- 2018-Feb 1-objects.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  site = Site.find_by_site_id(row["SITES.SITE_ID"].strip)
  catalog = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"].strip)

  if site && catalog
    cs = CatalogSite.new
    cs.site_id = site.id
    cs.catalog_id = catalog.id
    cs.save
  end

end