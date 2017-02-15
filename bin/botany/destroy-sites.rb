#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.where("site_id LIKE '577%'")

sites.find_each do |site|
  if site.site_name.include?("CAN ")
    counts = site.catalogs.map{|s| s.sites.count}.compact.uniq
    if counts.count == 1 && counts.first == 2
      CatalogSite.where(site_id: site.id).destroy_all
      site.destroy
    end
  end
end