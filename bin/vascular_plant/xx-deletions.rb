#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collection = "Vascular Plant"
xxtaxa = Taxon.search_by_prefix('xx')

pbar = ProgressBar.new("XX-NAMES", xxtaxa.count)
count = 0

candidate_deletions = Set.new

#date = Date.parse "2016-04-20"
#if taxon.update_date.strftime("%F") == date.strftime("%F") && taxon.updated_by == "JDOUBT"

CSV.open(output_dir(__FILE__) + "/xx-deletions.csv", 'w') do |csv|
  csv << ["ID Number", "xx-speckey", "xx-name"]
  xxtaxa.each do |taxon|
    similar = Taxon.find_by_scientific_name(taxon.scientific_name[2..-1])
    if similar
      valid_speckey = similar.speckey
      taxon.catalogs.each do |catalog|
        catalog_taxa = catalog.taxa.map(&:speckey)
        if catalog.collection == collection && (catalog_taxa & [valid_speckey, taxon.speckey]).present?
          ct = CatalogTaxon.where(speckey: taxon.speckey, mkey: catalog.mkey)
          #ct.first.delete
          csv << [catalog.id_number, taxon.speckey, taxon.scientific_name]
          candidate_deletions << taxon.speckey
        end
      end
    end
    count += 1
    pbar.set(count)
  end
end
pbar.finish

candidate_deletions.each do |candidate|
  taxon = Taxon.find(candidate)
  if taxon.leaf? && taxon.catalogs.empty?
    #taxon.destroy
  end
end