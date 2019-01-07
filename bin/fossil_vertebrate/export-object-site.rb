#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(collection: Collection::NUNAVUT)
pbar = ProgressBar.create(title: "PALEO", total: catalogs.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/nunavut-object-sites.csv", 'w') do |csv|
  csv << ["Collection", "CatalogNumber", "Collector", "Date Collected", "SiteID", "SiteName", "SiteDate"]
  catalogs.find_each do |catalog|
    pbar.increment
    next if catalog.sites.empty?
    site = catalog.sites.first
    csv << [
      catalog.collection,
      catalog.catalog_number,
      catalog.collector,
      catalog.date_collected,
      site.site_id,
      site.site_name,
      site.site_date
    ]
  end
end

pbar.finish