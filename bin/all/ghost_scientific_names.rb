#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

parser = ScientificNameParser.new

catalog_names = []
CatalogName.pluck(:scientific_name).uniq.each do |n|
    name = parser.parse(n) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
        catalog_names << name[:scientificName][:canonical]
    end
end


taxon_names = []
(Taxon.pluck(:scientific_name) + TaxonVariation.pluck(:variation)).uniq.each do |n|
    name = parser.parse(n) rescue nil
    if name && name[:scientificName] && name[:scientificName][:parsed]
        taxon_names << name[:scientificName][:canonical]
    end
end

catalog_names.uniq - taxon_names.uniq