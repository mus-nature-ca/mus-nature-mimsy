#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(collection: Collection::ZOOLOGY)

pbar = ProgressBar.create(title: "Catalogs", total: catalogs.size, autofinish: false, format: '%t %b>> %i| %e')
CSV.open(output_dir(__FILE__) + "/catalogs-sites-no-collected-places.csv", 'w') do |csv|
  catalogs.find_each do |o|
    pbar.increment
    next if !o.catalog_collection_places.empty?
    next if o.sites.map(&:location).compact.empty?
    csv << [o.collection, o.catalog_number]
  end
end
pbar.finish