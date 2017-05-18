#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#site_id = 474901 is "NO SITE", find Sites with more than one catalog
skeys = CatalogSite.where.not(site_id: 474901).group(:skey).having('count(*) > 1').order("count_all desc").count.keys
pbar = ProgressBar.create(title: "Sites", total: skeys.count, autofinish: false, format: '%t %b>> %i| %e')

problem_sites = []

skeys.each do |skey|
  site = Site.find(skey)
  byebug
  puts ""
  places = site.catalog_sites.
  if places.count > 1
    problem_sites << site.site_id
  end
  pbar.increment
end

pbar.finish

byebug
puts ""