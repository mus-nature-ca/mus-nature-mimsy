#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.select("CATALOGUE.CATEGORY1", "CATALOGUE.ID_NUMBER", "ITEMS_SITES.MKEY").joins("LEFT JOIN ITEMS_SITES ON CATALOGUE.MKEY = ITEMS_SITES.MKEY").where("ITEMS_SITES.MKEY IS NULL").where(collection: ZOOLOGY)

pbar = ProgressBar.create(title: "Catalogs", total: catalogs.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/catalogs-no-sites.csv", 'w') do |csv|
  csv << ["Collection", "ID Number"]
  catalogs.each do |catalog|
    pbar.increment
    csv << [catalog[0], catalog[1]]
  end
end

pbar.finish