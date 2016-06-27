#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

missing_arr = []
catalogs = Catalog.pluck(:mkey)
places = CatalogCollectionPlace.pluck(:mkey)
residuals = catalogs - places

pbar = ProgressBar.create(title: "MissingPlace", total: residuals.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/object-missing-place.csv", 'w') do |csv|
  csv << ["Collection", "ID Number"]
  residuals.each do |r|
    pbar.increment
    obj = Catalog.find(r)
    if !obj.sites.empty? && obj.sites.first.site_id != "NO SITE"
      csv << [obj.collection, obj.id_number]
    end
  end
end

pbar.finish