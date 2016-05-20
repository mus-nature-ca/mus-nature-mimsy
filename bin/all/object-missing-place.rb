#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

missing_arr = []
catalogs = Catalog.pluck(:mkey)
places = CatalogCollectionPlace.pluck(:mkey)
residual = catalogs - places

pbar = ProgressBar.create(title: "MissingPlace", total: residual.size, autofinish: false, format: '%t %b>> %i| %e')

residual.each do |r|
  pbar.increment
  obj = Catalog.find(r)
  if !obj.sites.empty? && obj.sites.first.site_id != "NO SITE"
    missing_arr << [obj.collection, obj.id_number]
  end
end

missing_arr.sort_by!{|collection, id| [collection, id]}
CSV.open(output_dir(__FILE__) + "/object-missing-place.csv", 'w') do |csv|
  csv << ["collection", "id_number"]
  missing_arr.each do |item|
    csv << item
  end
end

pbar.finish