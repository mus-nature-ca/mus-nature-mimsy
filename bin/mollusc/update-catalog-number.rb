#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(collection: "Mollusc").where("id_number LIKE 'CMNML-%'")

catalogs.each do |catalog|
  catalog_number = catalog.catalog_number.dup
  new_number = catalog_number.gsub(/^CMNML\-/, "CMNML ")
  if !Catalog.find_by_catalog_number(new_number).nil?
    puts catalog_number
  else
    catalog.catalog_number = new_number
    catalog.save
  end
end