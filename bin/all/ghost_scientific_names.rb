#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

parser = ScientificNameParser.new

catalog_names = {}
CatalogName.pluck(:scientific_name, :mkey).each do |cn|
    name = parser.parse(cn[0]) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
        catalog_names[name[:scientificName][:canonical]] = { mkey: cn[1], name: cn[0] }
    end
end

taxon_names = []
(Taxon.pluck(:scientific_name) + TaxonVariation.pluck(:variation)).uniq.each do |n|
    name = parser.parse(n) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
        taxon_names << name[:scientificName][:canonical]
    end
end

missing_names = catalog_names.keys.uniq - taxon_names.uniq

CSV.open(File.dirname(__FILE__) + "/ghost-names.csv", 'w') do |csv|
  csv << ["Collection", "ID Number", "Verbatim name", "Parsed name"]
  missing_names.each do |missing|
    mkey = catalog_names[missing][:mkey]
    cat = Catalog.find(mkey)
    csv << [cat.collection, cat.id_number, catalog_names[missing][:name], missing]
  end
end