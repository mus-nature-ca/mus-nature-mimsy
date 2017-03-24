#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objects = Catalog.where(collection: "Vascular Plant")
pbar = ProgressBar.create(title: "VascColl", total: objects.count, autofinish: false, format: '%t %b>> %i| %e')

objects.find_each do |obj|
  num = CatalogOtherNumber.new
  num.catalog_id = obj.id
  num.on_type = "stamped CMN accession number"
  num.other_number = obj.catalog_number
  num.save
  pbar.increment
end

pbar.finish