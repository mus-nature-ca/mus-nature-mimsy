#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objects = Catalog.joins("INNER JOIN items_sites ON (items_sites.mkey = catalogue.mkey) INNER JOIN sites ON (sites.skey = items_sites.skey)").where("sites.publish = 'N'").where("catalogue.publish = 'Y'").pluck("catalogue.category1", "catalogue.id_number", "sites.site_id")

pbar = ProgressBar.create(title: "Records", total: objects.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/unpublished_catalog_sites.csv", 'w') do |csv|
  csv << ["Collection", "ID Number", "Site ID"]
  objects.each do |o|
    pbar.increment
    csv << [o[0], o[1], o[2]]
  end
end

pbar.finish