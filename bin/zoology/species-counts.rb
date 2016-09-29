#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon_ids = %w(
1075964
1075965
1075968
1075970
1075973
1075974
)

pbar = ProgressBar.create(title: "TaxaCollections", total: taxon_ids.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/taxa-collections.csv"), 'w') do |csv|
  taxon_ids.each do |id|
    pbar.increment
    taxon = Taxon.find(id)
    collections = []
    taxon.self_and_descendants.each do |d|
      collections << d.catalogs.collect(&:collection)
    end
    csv << [id, collections.flatten.compact.uniq.join(",")]
  end
end
pbar.finish
