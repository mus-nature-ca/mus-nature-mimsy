#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

abbrev = "v."
tvs = TaxonVariation.joins(:taxon).where("taxonomy.taxon_name = 'Botany'").where("taxonomy_variations.variation LIKE '% #{abbrev} %'")
pbar = ProgressBar.create(title: "Abbreviations", total: tvs.count, autofinish: false, format: '%t %b>> %i| %e')
tvs.find_each do |tv|
  pbar.increment
  byebug
  puts ""
  updated = tv.variation.gsub(abbrev, "subsp.")
  if TaxonVariation.where(speckey: tv.speckey).where(scientific_name: updated).exists?
    tv.destroy
  else
    tv.scientific_name = updated
    tv.save
  end
end
pbar.finish