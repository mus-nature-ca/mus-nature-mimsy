#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

parser = ScientificNameParser.new
pbar = ProgressBar.create(title: "Compliant", total: Taxon.count, autofinish: false, format: '%t %b>> %i| %e')
CSV.open(output_dir(__FILE__) + "/non-code-scientific.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  Taxon.pluck("speckey","scientific_name").each_with_index do |t,i|
    pbar.increment
    if !parser.parse(t[1])[:scientificName][:parsed]
      csv << [t[0].to_i,t[1]]
    end
  end
end
pbar.finish