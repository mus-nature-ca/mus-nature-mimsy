#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ct = CatalogName.where(scientific_name: "TOP").pluck(:mkey) & Catalog.where(scientific_name: "TOP").pluck(:mkey)

CSV.open(output_dir(__FILE__) + "/catalog-name-top.csv", 'w') do |csv|
  csv << ["collection", "ID Number"]
  ct.uniq.each do |cat|
    obj = Catalog.find(cat)
    csv << [obj.collection, obj.id_number]
  end
end