#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon = Taxon.find_by_scientific_name("TOP")

CSV.open(output_dir(__FILE__) + "/catalogs-name-top.csv", 'w') do |csv|
  taxon.catalogs.each do |cat|
    csv << [cat.collection, cat.id_number]
  end
end