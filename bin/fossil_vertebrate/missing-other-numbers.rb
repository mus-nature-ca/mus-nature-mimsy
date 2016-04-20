#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.where("site_id LIKE ?", "CMNFV%")
pbar = ProgressBar.new("PALAEO-SITES", sites.count)
count = 0

STRIP_OUT = %r{
  (?i:LOC)\.?\s+?\??0?|
  (?i:GSC)\s+?|
  [()]
  }x

CSV.open(output_dir(__FILE__) + "/missing-other-numbers.csv", 'w') do |csv|
  csv << ["site_id", "status"]
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
        site.surveys.empty? #&&
#        site.other_numbers.empty?

    if !site.other_numbers.empty?
      cat_id = site.site_id.gsub(/([A-Z]+)\s+0+(\d+)/, '\1 \2')
      obj = Catalog.find_by_catalog(cat_id)
      
      if !obj
        csv << [site.site_id, "missing object #{cat_id}"]
      else
        obj_other_numbers = obj.other_numbers.map(&:other_number) rescue []

        old_numbers = {}
        site.other_numbers.each do |o|
          old_numbers[o.other_number.gsub(STRIP_OUT, "").to_s] = o.other_number.to_s
        end
        new_numbers = obj.sites.first.other_numbers.map(&:other_number) rescue []
        new_site_name = obj.sites.first.site_name.downcase rescue ""

        old_numbers.keys.each do |old_number|
          if new_site_name.gsub(/[()]/,"") =~ /#{old_number.downcase}/
            old_numbers.delete old_number.to_s
          end
        end

        obj_other_numbers.each do |other_number|
          if old_numbers.include? other_number
            old_numbers.delete other_number
          end
        end

        residuals = old_numbers.keys - new_numbers

        if residuals.size > 0
          csv << [site.site_id, "missing other number #{residuals.map{|v| old_numbers[v]}.join(', ')}"]
        end
      end

    end

#    msg = nil
#    if obj.nil?
#      msg = "object missing"
#    elsif obj && obj.sites.empty?
#      msg = "object missing site"
#    elsif obj && !obj.sites.empty?
#      obj_site = obj.sites.first.site_id
#      if obj_site[0] != "P" && obj_site != "NO SITE"
#        msg = "object site = #{obj_site} (not P%)"
#      end
    end
  end
end
pbar.finish