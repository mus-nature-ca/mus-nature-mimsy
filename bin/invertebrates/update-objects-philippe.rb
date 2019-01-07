#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Objects_ABS_Hunter Series_update.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CATALOGUE.ID_NUMBER"]
  obj = Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"])

  #update catalog record
  ct = CatalogTaxon.where({mkey: obj.id, taxonomy: row["ITEMS_TAXONOMY.TAXONOMY_2"]}).first
  ct.note = row["ITEMS_TAXONOMY.NOTE_2"]
  ct.save

end