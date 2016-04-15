#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/onEMJQ6W

site_ids = Site.where("site_id LIKE ?", "CMNFV%").pluck(:site_id).sort
pbar = ProgressBar.new("PALAEO-SITES", site_ids.size)
count = 0

CSV.open(File.dirname(__FILE__) + "/missing-sites.csv", 'w') do |csv|
  csv << ["site_id", "computed_object_id", "issue"]
  site_ids.each do |site_id|
    count += 1
    pbar.set(count)
#    if site.catalogs.empty? && 
#        site.events.empty? && 
#        site.media.empty? && 
#        site.people.empty? &&
#        site.collections.empty? &&
#        site.coordinates.empty? &&
#        site.cultures.empty? &&
#        site.descriptions.empty? &&
#        site.excavations.empty? &&
#        site.features.empty? &&
#        site.maps.empty? &&
#        site.measurements.empty? &&
#        site.permits.empty? &&
#        site.photos.empty? &&
#        site.surveys.empty?

    cat_id = site_id.gsub(/([A-Z]+)\s+0+(\d+)/, '\1 \2')
    obj = Catalog.find_by_catalog(cat_id) #so slow!!!
    msg = nil
    if obj.nil?
      msg = "object missing"
    elsif obj && obj.sites.empty?
      msg = "object missing site"
    elsif obj && !obj.sites.empty?
      obj_site = obj.sites.first.site_id
      if obj_site[0] != "P" && obj_site != "NO SITE"
        msg = "object site = #{obj_site} (not P%)"
      end
    end
    csv << [site_id, cat_id, msg] if msg
  end
end
pbar.finish