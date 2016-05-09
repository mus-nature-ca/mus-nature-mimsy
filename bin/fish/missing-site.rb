#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objects = Catalog.where(collection_code: "CMNFI")
pbar = ProgressBar.create(title: "Fish-Missing-Sites", total: objects.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/fish-missing-sites.csv", 'w') do |csv|
  csv << ["object", "site_id", "site_name", "note"]
  objects.each do |obj|
    pbar.increment
    if obj.site && obj.sites.empty?
      site = Site.find_by(site_name: obj.site)
      if site
        CatalogSite.create({ mkey: obj.mkey, skey: site.skey })
        csv << [obj.id_number, site.site_id, site.site_name, "created link"]
      else
        csv << [obj.id_number, obj.site, nil, "site unknown"]
      end
    elsif obj.site.nil? && obj.sites.empty?
      csv << [obj.id_number, nil, nil, "site missing"]
    end
  end
end
pbar.finish