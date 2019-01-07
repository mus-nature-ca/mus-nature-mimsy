#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalog_counts = CatalogTaxon.group(:mkey).count

CSV.open(output_dir(__FILE__) + "/catalogs-multiple-taxa.csv", 'w') do |csv|
  csv << ["CatalogNumber", "Collection", "ScientificName", "Linked Taxa"]
  catalog_counts.each do |pr|
    next if pr[1] < 2
    linked_taxa = CatalogTaxon.where(mkey: pr[0]).pluck(:scientific_name, :affiliation).map{|a| [a[0], a[1]].join("|")}.join("|")
    catalog = Catalog.find(pr[0])
    csv << [catalog.catalog_number, catalog.collection, catalog.scientific_name, linked_taxa]
  end
end