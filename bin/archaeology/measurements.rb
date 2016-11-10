#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collections = "NU Archaeology"

measurements = CatalogMeasurement.joins(:catalog).where("catalogue.category1": collections)

pbar = ProgressBar.create(title: "ARCH", total: measurements.count, autofinish: false, format: '%t %b>> %i| %e')
CSV.open(output_dir(__FILE__) + "/nu-archaeology-measurements.csv", 'w') do |csv|
  csv << ["ID Number"] + CatalogMeasurement.attribute_names
  measurements.find_each do |measurement|
    pbar.increment
    csv << [measurement.catalog.catalog_number] + measurement.attributes.values
  end
end
pbar.finish