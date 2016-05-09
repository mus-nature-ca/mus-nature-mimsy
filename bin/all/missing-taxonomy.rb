#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

pbar = ProgressBar.create(title: "Missing", total: Catalog.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/missing-taxonomy.csv", 'w') do |csv|
  csv << ["mkey", "Collection", "ID Number"]
  Catalog.find_each do |obj|
    pbar.increment
    next if obj.legal_status != "PERMANENT COLLECTION"
    next if !obj.taxa.empty?
    next if obj.scientific_name == "TOP"
    next if obj.names.map(&:scientific_name).compact.empty?
    csv << [obj.mkey, obj.collection, obj.id_number]
  end
end
pbar.finish