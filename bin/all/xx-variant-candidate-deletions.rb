#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

xxtaxa = TaxonVariation.search_by_prefix('xx')

pbar = ProgressBar.create(title: "XX-NAMES", total: xxtaxa.count, autofinish: false, format: '%t %b>> %i| %e')

scheduled = []

#CSV.open(output_dir(__FILE__) + "/xx-candidate-variant-deletions.csv", 'w') do |csv|
#  csv << ["taxvarkey", "speckey", "xxScientific Name", "Taxonomic System"]
  xxtaxa.each do |xxtaxon|
    pbar.increment
    variants = TaxonVariation.where(speckey: xxtaxon.speckey).map(&:scientific_name)
    taxon_name = Taxon.find(xxtaxon.speckey)
    ct = CatalogTaxon.where(speckey: xxtaxon.speckey)
    if variants.include?(xxtaxon.scientific_name[2..-1]) && 
      taxon_name.scientific_name != xxtaxon.scientific_name
      scheduled << xxtaxon
#      xxtaxon.destroy
    end
  end
  #end
pbar.finish