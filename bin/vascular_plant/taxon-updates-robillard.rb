#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find(4575)

old_name = "Alopecurus alpinus"
new_name = "Alopecurus borealis"
determiner = "Crins, W.J."

group.members.each do |member|
  catalog = Catalog.find(member.table_key)

  if catalog.scientific_name == old_name && 
     catalog.catalog_taxa.first.scientific_name == new_name && 
     catalog.catalog_taxa.first.attributor == determiner &&
     catalog.names.count == 1 &&
     catalog.names.first.scientific_name == old_name

     det = catalog.catalog_taxa.first
     name = catalog.names.first

     name.attributor = det.attributor
     name.attrib_date = det.attrib_date
     name.type = "previous name"
     name.prior_name = true
     name.save

     det.attributor = nil
     det.attrib_date = 2017
     det.save

     newname = CatalogName.new
     newname.catalog_id = catalog.id
     newname.scientific_name = new_name
     newname.attrib_date = 2017
     newname.type = "item name"
     newname.note = "taxonomic update without examination"
     newname.save

     catalog.scientific_name = new_name
     catalog.save

     puts catalog.catalog_number

  end

end