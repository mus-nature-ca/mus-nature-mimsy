#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

parser = ScientificNameParser.new

catalogs = CatalogName.pluck(:scientific_name).uniq
pbar = ProgressBar.new("CATALOG-NAMES", catalogs.size)
count = 0

catalog_names = {}
catalogs.each do |cn|
    name = parser.parse(cn) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
      catalog_names[name[:scientificName][:canonical]] = { name: cn }
    end
    count += 1
    pbar.set(count)
end
pbar.finish


known_names = (Taxon.pluck(:speckey, :scientific_name) + TaxonVariation.pluck(:speckey, :scientific_name)).uniq
pbar = ProgressBar.new("TAXON-NAMES", known_names.size)
count = 0

taxon_names = {}
known_names.each do |tn|
    name = parser.parse(tn[1]) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
      taxon_names[name[:scientificName][:canonical]] = { speckey: tn[0], name: tn[1] }
    end
    count += 1
    pbar.set(count)
end
pbar.finish


missing_names = catalog_names.keys.uniq - taxon_names.keys.uniq
pbar = ProgressBar.new("GHOST-NAMES", missing_names.size)
count = 0

CSV.open(output_dir(__FILE__) + "/ghost-names-revised.csv", 'w') do |csv|
  csv << ["Collection", "ID Number", "Verbatim name", "Resolved name", "Candidate name", "Candidate speckey"]
  missing_names.each do |missing|

    resolved_name = nil
    candidate_name = nil
    candidate_speckey = nil
    response = RestClient::Request.execute(
      method: :get,
      url: 'http://resolver.globalnames.org/name_resolvers.json?best_match_only=true&names=' + URI::encode(missing)
    ) rescue nil
    result =  JSON.parse(response, :symbolize_names => true)[:data][0][:results][0] rescue nil
    if result && result[:match_type] < 6
      resolved_name = result[:canonical_form]
      candidate_name = taxon_names[result[:canonical_form]][:name] rescue nil
      candidate_speckey = taxon_names[result[:canonical_form]][:speckey] rescue nil
    end

    name = catalog_names[missing][:name]
    mkeys = CatalogName.where(scientific_name: name).pluck(:mkey).uniq
    mkeys.each do |mkey|
      cat = Catalog.find(mkey)
      csv << [cat.collection, cat.id_number, catalog_names[missing][:name], resolved_name, candidate_name, candidate_speckey]
    end

    count += 1
    pbar.set(count)
  end
end
pbar.finish