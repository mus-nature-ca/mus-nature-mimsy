#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

=begin
catalog_ids = Catalog.where(collection: Collection::PALAEOBIOLOGY).pluck(:id)

sites = Set.new
published_site_ids = []

catalog_ids.each do |id|
  site = CatalogSite.find_by_catalog_id(id).site rescue nil
  next if !site
  next if sites.include?(site.site_id)
  sites.add site.site_id
  puts site.site_id
  published_site_ids << site.site_id if site.publish
end
=end

site_ids = ["P5310", "P8720", "P8217", "P7683", "P7687", "P7659", "P7674", "P7655", "P8210", "P7656", "P7681", "P7669", "P7680", "P7677", "P3514", "P7661", "P7678", "P8735", "P7653", "P8722", "P9703", "P9701", "P9707", "P9706", "P9709", "P9710", "P7684", "P7668", "P7658", "P8216", "P7657", "P8733", "P8213", "P7671", "P8740", "P7666", "P7916", "P8723", "P8727", "P8739", "P9702", "P7686", "P7676", "P8729", "P8212", "P8724", "P7660", "P8721", "P8211", "P8728", "P8737", "P8731", "P7667", "P7670", "P7682", "P8736", "P8734", "P7688", "P7662", "P7766", "P9708", "P9704", "P8742", "P7679", "P9705", "P8732", "P8215", "P7914", "P8725", "P8730", "P8726", "P8209", "P8741", "P7663", "P7665", "P7654", "P8214", "P8738", "P7675", "P7685", "P7673", "P7672", "P4308", "P201201", "P2313", "P7689", "P2822", "P2823", "P3632", "P5430", "P91100", "P7915", "P5625", "P3516", "P9200"]

ids = Site.where(site_id: site_ids).pluck(:id)

ids.each do |id|
  cs = CatalogSite.where(site_id: id)
  collections = cs.map{ |o| o.catalog.collection }.uniq
  if (collections - Collection::PALAEOBIOLOGY).empty?
    Site.find(cs.first.site_id).update({ publish: false })
  else
    puts Site.find(cs.first.site_id).site_id
  end
end