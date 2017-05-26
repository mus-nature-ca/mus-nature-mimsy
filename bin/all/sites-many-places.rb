#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#site_id = 474901 is "NO SITE", find Sites with more than one catalog
skeys = CatalogSite.where.not(site_id: 474901).group(:skey).having('count(*) > 1').order("count_all desc").count.keys
pbar = ProgressBar.create(title: "Sites", total: skeys.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/sites-many-places.csv", 'w') do |csv|
  csv << ["collections", "site_id", "site_name", "places"]
end

Parallel.map(skeys.in_groups_of(10, false), progress: "Problems", in_processes: 4) do |group|
  group.each do |skey|
    site = Site.find(skey)
    catalog_ids = site.catalog_sites.pluck(:catalog_id)
    place_ids = []
    catalog_ids.in_groups_of(30, false).each do |group|
      place_ids << CatalogCollectionPlace.where(catalog_id: group).pluck(:place_id).uniq
    end

    uniq_place_ids = place_ids.reduce(:+).uniq

    if uniq_place_ids.count > 1
      summary = []
      collections = []
      uniq_place_ids.each do |place_id|
        ccp = CatalogCollectionPlace.where({place_id: place_id})
        place = ccp.first.catalog[:place_collected]
        common = ccp.map(&:catalog_id) & catalog_ids
        common.in_groups_of(30, false).each do |group|
          collections << Catalog.where(id: group).pluck(:collection).uniq
        end
        summary << place + " (#{common.count})"
      end
      CSV.open(output_dir(__FILE__) + "/sites-many-places.csv", 'a') do |csv|
        csv << [collections.flatten.uniq.sort.join(", "), site.site_id, site.site_name, summary.join(" | ")]
      end
    end
  end
end