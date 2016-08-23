#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collections = ["Amphibian and Reptile", "Annelid", "Bird", "Crustacea", "Fish", "General Invertebrate", "Insect", "Mammal", "Mollusc", "Parasite"]

cms = CatalogMeasurement.joins(:catalog).where("catalogue.category1": collections)

CSV.open(output_dir(__FILE__) + "/CatalogMeasurement_list.csv", 'w') do |csv|
  csv << ["part_measured", "id_number"]
  cms.collect{|parts| parts.part_measured}.compact.uniq.sort.each do |cm|
    records = CatalogMeasurement.where(part_measured: cm)
    id_number = (records.count == 1) ? records.first.catalog.id_number : nil
    csv << [cm, id_number]
  end
end

coms = CatalogOtherMeasurement.joins(:catalog).where("catalogue.category1": collections)

CSV.open(output_dir(__FILE__) + "/CatalogOtherMeasurement_list.csv", 'w') do |csv|
  csv << ["part_measured", "id_number"]
  coms.collect{|parts| parts.part_measured}.compact.uniq.sort.each do |cm|
    records = CatalogOtherMeasurement.where(part_measured: cm)
    id_number = (records.count == 1) ? records.first.catalog.id_number : nil
    csv << [cm, id_number]
  end
end