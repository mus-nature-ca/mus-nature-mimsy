#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ct = CatalogTaxon.group(:mkey).having("count(speckey) > 1").count.to_a

CSV.open(output_dir(__FILE__) + "/botany-missing-type-status.csv", 'w') do |csv|
  csv << ["catalog_number", "taxonomy"]
end

Parallel.map(ct.in_groups_of(40, false), progress: "Catalogs", in_processes: 8) do |group|
  CSV.open(output_dir(__FILE__) + "/botany-missing-type-status.csv", 'a') do |csv|
    group.each do |id, count|
      catalog = Catalog.find(id)
      next if !Collection::BOTANY.include?(catalog.collection)
      taxon_names = CatalogTaxon.where(catalog_id: id).where(type_status: nil).pluck(:scientific_name)
      if taxon_names.count > 1
        csv << [catalog.catalog_number, taxon_names]
      end
    end
  end
end
