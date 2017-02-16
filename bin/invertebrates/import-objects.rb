#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-objects.csv"

CSV.foreach(file, :headers => true) do |row|
  obj = Catalog.new
  obj.catalog_number = row["CATALOGUE.ID_NUMBER"]
  obj.collection = row["CATALOGUE.CATEGORY1"]
  obj.scientific_name = row["CATALOGUE.ITEM_NAME"]
  obj.whole_part = "whole"
  obj.item_count = row["CATALOGUE.ITEM_COUNT"]
  obj.sex = row["CATALOGUE.SEX"]
  obj.collector = row["CATALOGUE.COLLECTOR"]
  obj.date_collected = row["CATALOGUE.DATE_COLLECTED"]
  obj.note = row["CATALOGUE.NOTE"]
  obj.save

  #Find object again - damn Oracle!
  obj = Catalog.find_by_catalog_number(obj.catalog_number)

  #create link to Taxonomy
  tax = Taxon.find_by_scientific_name(row["ITEMS_TAXONOMY.TAXONOMY"])
  obj_tax = CatalogTaxon.new
  obj_tax.taxon_id = tax.id
  obj_tax.catalog_id = obj.id
  obj_tax.attributor = row["ITEMS_TAXONOMY.ATTRIBUTOR"]
  obj_tax.save

  #create link to Person (collector)
  pers = Person.find_by_preferred_name(obj.collector)
  cat_coll = CatalogCollector.new
  cat_coll.catalog_id = obj.id
  cat_coll.person_id = pers.id
  cat_coll.relationship = "collector"
  cat_coll.save

  #measurements
  (1..3).each do |num|
    part = row["MEASUREMENTS.PART_MEASURED_#{num}"] rescue nil
    if !part.nil? && !part.empty?
      measurement = CatalogMeasurement.new
      measurement.catalog_id = obj.id
      measurement.part_measured = part
      measurement.dimension1 = row["MEASUREMENTS.DIMENSION1_#{num}"]
      measurement.measurement_type = row["MEASUREMENTS.MEASUREMENT_TYPE_#{m}"]
      measurement.unit1 = row["MEASUREMENTS.UNIT1_#{m}"]
      measurement.save
    end
  end

  #other number
  if row["OTHER_NUMBERS.OTHER_NUMBER"]
    other_number = CatalogOtherNumber.new
    other_number.catalog_id = obj.id
    other_number.other_number = row["OTHER_NUMBERS.OTHER_NUMBER"]
    other_number.on_type = row["OTHER_NUMBERS.ON_TYPE"]
    other_number.save
  end

end