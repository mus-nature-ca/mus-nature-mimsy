#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collection = "Vascular Plant"
#loan_number = "LP2012-0039"
#loan = Loan.find_by_loan_number(loan_number)
catalogs = Catalog.where(collection: "Vascular Plant")

pbar = ProgressBar.create(title: "Unlinked Taxonomy", total: catalogs.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/#{collection}-linked-taxonomy.csv", 'w') do |csv|
  csv << ["ID Number", "speckey", "Scientific Name"]
  catalogs.each do |catalog|
    pbar.increment
    next if !catalog.catalog_taxa.empty?
    item_dets = catalog.names.where(type: "item name")
    next if item_dets.size > 1 || item_dets.empty?
    item_det = item_dets.first
    taxon = Taxon.find_by_scientific_name(item_det.scientific_name)
    taxon_variation = TaxonVariation.find_by_scientific_name(item_det.scientific_name)
    next if taxon.nil? && taxon_variation.nil?
    ct = CatalogTaxon.new
    if taxon.respond_to?(:speckey)
      ct.speckey = taxon.speckey
      scientific_name = taxon.scientific_name
    end
    if taxon_variation.respond_to?(:taxvarkey)
      ct.speckey = taxon_variation.speckey
      ct.taxvarkey = taxon_variation.taxvarkey
      scientific_name = taxon_variation.scientific_name
    end
    ct.mkey = catalog.mkey
    ct.save
    csv << [catalog.id_number, ct.speckey, scientific_name]
  end
end
pbar.finish