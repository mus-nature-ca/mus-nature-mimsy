#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where("id_number LIKE 'CMN%' AND place_collected LIKE '%McAbee%'")

pbar = ProgressBar.new("NEW-SITES", catalogs.count)
count = 0

new_site = Site.find_by_site_id("P8461")

CSV.open(output_dir(__FILE__) + "/site-reassociations.csv", 'w') do |csv|
  csv << ["ID Number"]
  catalogs.find_each do |catalog|
    site = catalog.sites.first
    if site.site_id != "P8461"
      catalog.site = new_site.site_name
      catalog.save
      catalog.sites << new_site
      sc = CatalogSite.find_by(skey: site.skey, mkey: catalog.mkey)
      sc.delete
      site.reload
      site.destroy if site.catalogs.empty?
    end
    count += 1
    pbar.set(count)
  end
end
pbar.finish