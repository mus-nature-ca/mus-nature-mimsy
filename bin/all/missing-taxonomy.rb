#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

count = 0
pbar = ProgressBar.new("MISSING", Catalog.count)

CSV.open(output_dir(__FILE__) + "/missing-taxonomy.csv", 'w') do |csv|
  csv << ["mkey", "Collection", "ID Number"]
  Catalog.find_each do |obj|
    count += 1
    pbar.set(count)
    next if obj.legal_status != "PERMANENT COLLECTION"
    next if !obj.taxa.empty?
    csv << [obj.mkey, obj.collection, obj.id_number]
  end
end
pbar.finish