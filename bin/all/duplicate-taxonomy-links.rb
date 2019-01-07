#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ids = CatalogTaxon.select(:mkey).group(:mkey,:speckey).having("count(*) >= 2").pluck(:mkey).uniq

ids.each do |id|
  catalog = Catalog.find(id)
  next if catalog.collection != "Palynology"
  ct = catalog.catalog_taxa
  links = ct.map{|t| t.as_json.except("authlinkkey")}
  if links[0] == links[1]
    ct.first.destroy
  end
end