#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

parser = ScientificNameParser.new

catalogs = CatalogName.pluck(:scientific_name).uniq
pbar = ProgressBar.create(title: "Catalog Names", total: catalogs.size, autofinish: false, format: '%t %b>> %i| %e')

ignored = ["undetermined specimen", "indeterminate specimen", "unidentified specimen"]

catalog_names = {}
catalogs.each do |cn|
    name = parser.parse(cn) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed] && ignored.select{|i| i.match(/^#{cn.gsub(/[^A-Za-z\s]/, "")}/i)}.empty?
      catalog_names[name[:scientificName][:canonical]] = { name: cn }
    end
    pbar.increment
end
pbar.finish

known_names = (Taxon.pluck(:speckey, :scientific_name) + TaxonVariation.pluck(:speckey, :scientific_name)).uniq
pbar = ProgressBar.create(title: "Known Names", total: known_names.size, autofinish: false, format: '%t %b>> %i| %e')

taxon_names = {}
known_names.each do |tn|
    name = parser.parse(tn[1]) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
      taxon_names[name[:scientificName][:canonical]] = { speckey: tn[0], name: tn[1] }
    end
    pbar.increment
end
pbar.finish

missing_names = catalog_names.keys.uniq - taxon_names.keys.uniq

pbar = ProgressBar.create(title: "Ghost Names", total: missing_names.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/ghost-names-revised.csv", 'w') do |csv|
  csv << ["Collection", "ID Number", "Verbatim object name", "Type", "Taxonomy Name(s)"]
  missing_names.each do |missing|

#    resolved_name = nil
#    candidate_name = nil
#    candidate_speckey = nil
#    response = RestClient::Request.execute(
#      method: :get,
#      url: 'http://resolver.globalnames.org/name_resolvers.json?best_match_only=true&names=' + URI::encode(missing)
#    ) rescue nil
#    result =  JSON.parse(response, :symbolize_names => true)[:data][0][:results][0] rescue nil
#    if result && result[:match_type] < 6
#      resolved_name = result[:canonical_form]
#      candidate_name = taxon_names[result[:canonical_form]][:name] rescue nil
#      candidate_speckey = taxon_names[result[:canonical_form]][:speckey] rescue nil
#    end

    name = catalog_names[missing][:name]
    cns = CatalogName.where(scientific_name: name).pluck(:mkey, :tna_type).uniq
    cns.each do |cn|
      cat = Catalog.find(cn[0])
#      csv << [cat.collection, cat.id_number, catalog_names[missing][:name], resolved_name, candidate_name, candidate_speckey]
      csv << [cat.collection, cat.id_number, name, cn[1], cat.taxa.map(&:scientific_name).join(" | ")]
    end
    pbar.increment
  end
end
pbar.finish