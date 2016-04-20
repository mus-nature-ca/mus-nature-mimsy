#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

missing_arr = []
catalogs = Catalog.pluck(:mkey)
places = CatalogCollectionPlace.pluck(:mkey)
residual = catalogs - places
residual.each do |r|
  obj = Catalog.find(r)
  if !obj.sites.empty? && obj.sites.first.site_name != "NO SITE"
    missing_arr << [obj.collection, obj.id_number]
  end
end

missing_arr.sort_by!{|collection, id| [collection, id]}
file = output_dir(__FILE__) + "/object-missing-place.csv"
File.open(file,'w'){ |f| f << missing_arr.map(&:to_csv).join }