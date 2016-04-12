#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/onEMJQ6W

sites = Site.where("site_id LIKE ?", "CMNFV%")
pbar = ProgressBar.new("PALAEO-SITES", sites.size)
count = 0

CSV.open(File.dirname(__FILE__) + "/sites-removed-other.csv", 'w') do |csv|
  csv << ["skey", "site_id", "site_name", "description", "create_date"]
  sites.each do |site|
    count += 1
    pbar.set(count)
    if site.catalogs.empty? && 
        site.events.empty? && 
        site.media.empty? && 
        site.people.empty? &&
        site.collections.empty? &&
        site.coordinates.empty? &&
        site.cultures.empty? &&
        site.descriptions.empty? &&
        site.excavations.empty? &&
        site.features.empty? &&
        site.maps.empty? &&
        site.measurements.empty? &&
        site.permits.empty? &&
        site.photos.empty? &&
        site.surveys.empty?
      csv << [site.skey, site.site_id, site.site_name, site.description, site.create_date]
      site.destroy
    end
  end
end
pbar.finish