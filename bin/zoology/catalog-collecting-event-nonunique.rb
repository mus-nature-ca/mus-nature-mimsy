#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#site_id = 474901 is "NO SITE", find Sites with more than one catalog
catalog_sites = CatalogSite.where.not(site_id: 474901).group(:skey).having("COUNT(mkey) > 1").count

CSV.open(output_dir(__FILE__) + "/catalogs-collecting-events-nonunique.csv", 'w') do |csv|
  csv << ["Collection", "Catalog Number", "SiteID", "Site Name", "Latitude", "Longitude", "Catalog Date", "Catalog Collector"]
  catalog_sites.each do |key,val|
    site = Site.find(key)
    next if site.site_name == "NO SITE"
    catalog_ids = CatalogSite.where(site_id: key).pluck(:catalog_id)
    catalog_ids.in_groups_of(50, false) do |group|
      catalogs = Catalog.where(id: group).where(collection: Collection::ZOOLOGY)
      dates = Set.new
      collectors = Set.new
      problem_catalogs = []
      catalogs.find_each do |catalog|
        dates.add(catalog.date_collected)
        collectors.add(catalog.collector)
        problem_catalogs << catalog
      end
      if dates.size > 1 || collectors.size > 1
        problem_catalogs.each do |catalog|
          csv << [catalog.collection, catalog.catalog_number, site.site_id, site.site_name, site.lat, site.lng, catalog.date_collected, catalog.collector]
        end
      end
    end
  end
end