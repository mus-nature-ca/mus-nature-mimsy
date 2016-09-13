#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objs = CatalogCollectionPlace.where("placekey = 24914 or placekey = 13").pluck(:catalog_id).uniq

pbar = ProgressBar.create(title: "MediaCount", total: objs.count, autofinish: false, format: '%t %b>> %i| %e')

catalogs = []

objs.find_each do |obj|
  pbar.increment
  catalog = obj.catalog rescue nil
  if !catalog.nil? && !catalog.catalog_media.empty?
    catalogs << catalog
  end
end

byebug
puts ""
pbar.finish