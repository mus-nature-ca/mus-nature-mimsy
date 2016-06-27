#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objs = Catalog.pluck(:mkey)
taxa = CatalogTaxon.pluck(:mkey).uniq
residual = objs - taxa

pbar = ProgressBar.create(title: "MissingTaxonomy", total: residual.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/missing-taxonomy.csv", 'w') do |csv|
  residual.each do |mkey|
    pbar.increment
    obj = Catalog.find(mkey)
    next if obj.legal_status != "PERMANENT COLLECTION"
    next if obj.scientific_name == "TOP" || obj.scientific_name == "Undet." || (/sp\.|indet|cf\s+|\?/).match(obj.scientific_name)
    next if !obj.taxa.empty?
    next if obj.names.map(&:scientific_name).compact.empty?
    csv << [obj.mkey, obj.collection, obj.id_number, obj.scientific_name]
  end
end

pbar.finish