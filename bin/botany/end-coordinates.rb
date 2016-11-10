#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.joins(:catalogs).where("catalogue.category1": Collection::BOTANY)

pbar = ProgressBar.create(title: "SITES", total: sites.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/botany-end-coordinates.csv", 'w') do |csv|
  csv << Site.custom_attribute_names
  sites.find_each do |site|
    pbar.increment
    if !site.end_latitude_dec.nil? || !site.end_longitude_dec.nil?
      csv << site.custom_attributes.values
    end
  end
end
pbar.finish