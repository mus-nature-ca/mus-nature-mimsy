#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

species = Taxon.where(rank: "SPECIES")
pbar = ProgressBar.create(title: "Homonymy", total: species.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/homonymy.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  species.find_each do |t|
    pbar.increment
    if t.collection != t.parent.collection
      csv << [t.speckey.to_i, t.scientific_name]
    end rescue nil
  end
end
pbar.finish