#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalog_sites = CatalogSite.group(:skey).having("COUNT(mkey) > 1").count

CSV.open(output_dir(__FILE__) + "/catalogs-collecting-events.csv", 'w') do |csv|
  csv << ["Collections", "SiteID", "Site Name", "ID Numbers", "Catalog Dates", "Catalog Collectors"]
end

Parallel.map(catalog_sites.to_a.in_groups_of(20, false), progress: "Exporting collecting events", in_processes: 8) do |group|
  CSV.open(output_dir(__FILE__) + "/catalogs-collecting-events.csv", 'a') do |csv|
    group.each do |key,sum|
      site = Site.find(key)
      catalogs = CatalogSite.where(site_id: key).map(&:catalog)
      collections = catalogs.map(&:collection).compact.uniq.sort.join("|")
      catalog_ids = catalogs.map(&:catalog_number).compact.uniq.sort.join("|")
      dates_differ = false
      collectors_differ = false
      dates = catalogs.map(&:date_collected).compact.uniq
      collectors = catalogs.map(&:collector).compact.uniq
      if dates.count > 1
        dates_differ = true
      end
      if collectors.count > 1
        collectors_differ = true
      end
      if dates_differ || collectors_differ
        csv << [collections, site.site_id, site.site_name, catalog_ids, dates.join("|"), collectors.join("|")]
      end
    end
  end
end