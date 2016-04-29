#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

species = Taxon.where(rank: "SPECIES")

count = 0
pbar = ProgressBar.new("HOMONYMY", species.count)

CSV.open(output_dir(__FILE__) + "/homonymy.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  species.find_each do |t|
    count += 1
    pbar.set(count)
    if t.collection != t.parent.collection
      csv << [t.speckey.to_i, t.scientific_name]
    end rescue nil
  end
end
pbar.finish