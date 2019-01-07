#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

CSV.foreach("/Users/dshorthouse/Desktop/updates.txt", :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  catalog = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"])
  if catalog.names.count == 1 && catalog.catalog_taxa.count == 1
    ct = catalog.catalog_taxa.first
    cn = catalog.names.first
    cn.attributor = ct.attributor
    cn.attrib_date = ct.attrib_date
    cn.save
  end
end