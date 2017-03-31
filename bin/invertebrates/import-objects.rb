#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-objects-utf16.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CATALOGUE.ID_NUMBER"]

  #Get the linked site
  site = Site.find_by_site_id(row["SITES.SITE_ID"].strip)

  #Get the linked place
  place_collected = row["CATALOGUE.PLACE_COLLECTED"].strip rescue nil

  #create new catalog record
  obj = Catalog.new
  obj.catalog_number = row["CATALOGUE.ID_NUMBER"].strip
  obj.collection = row["CATALOGUE.CATEGORY1"].strip
  obj.scientific_name = row["CATALOGUE.ITEM_NAME"].strip
  obj.scientific_name[0] = obj.scientific_name[0].capitalize
  obj.whole_part = row["CATALOGUE.WHOLE_PART"].strip rescue nil
  obj.materials = row["CATALOGUE.MATERIALS"].strip rescue nil
  obj.item_count = row["CATALOGUE.ITEM_COUNT"].strip.to_i rescue nil
  obj.sex = row["CATALOGUE.SEX"].strip rescue nil
  obj.collector = row["CATALOGUE.COLLECTOR"].strip rescue nil
  obj.date_collected = row["CATALOGUE.DATE_COLLECTED"].strip rescue nil
  obj.description = row["CATALOGUE.DESCRIPTION"].strip rescue nil
  obj.note = row["CATALOGUE.NOTE"].strip rescue nil
  obj.site = site.site_id
  obj.place_collected = place_collected
  obj.home_location = row["CATALOGUE.HOME_LOCATION"].strip rescue nil
  obj.credit_line = row["CATALOGUE.CREDIT_LINE"].strip rescue nil
  obj.gbif = true
  obj.save

  #Find object again - damn Oracle!
  obj = Catalog.find_by_catalog_number(obj.catalog_number)

  #create link to Taxonomy
  taxon = row["ITEMS_TAXONOMY.TAXONOMY"].strip
  tax = Taxon.find_by_scientific_name(taxon)
  #Find a variant if verbatim not found
  if tax.nil?
    tax = TaxonVariation.find_by_scientific_name(taxon).taxon rescue nil
  end
  if !tax.nil?
    obj_tax = CatalogTaxon.new
    obj_tax.taxon_id = tax.id
    obj_tax.catalog_id = obj.id
    obj_tax.attributor = row["ITEMS_TAXONOMY.ATTRIBUTOR"].strip rescue nil
    obj_tax.save
  end

  #create link to Catalog Name
  cn = CatalogName.new
  cn.scientific_name = obj.scientific_name
  cn.catalog_id = obj.id
  cn.save

  #create link to Person (collector)
  pers = Person.find_by_preferred_name(obj.collector)
  cat_coll = CatalogCollector.new
  cat_coll.catalog_id = obj.id
  cat_coll.person_id = pers.id
  cat_coll.relationship = "collector"
  cat_coll.save

  #create link to collected date
  cd = CollectedDate.new
  cd.catalog_id = obj.id
  cd.date_text = obj.date_collected
  cd.save

  #measurements
  (1..3).each do |num|
    part = row["OTHER_MEASUREMENTS.PART_MEASURED_#{num}"].strip rescue nil
    if !part.nil?
      om = CatalogOtherMeasurement.new
      om.catalog_id = obj.id
      om.part_measured = part.downcase
      om.measurement = row["OTHER_MEASUREMENTS.MEASUREMENT_#{num}"].strip rescue nil
      om.om_type = row["OTHER_MEASUREMENTS.OM_TYPE_#{num}"].strip.downcase rescue nil
      om.unit = row["OTHER_MEASUREMENTS.UNIT_#{num}"].strip rescue nil
      om.save
    end
  end

  #other number
  if row["OTHER_NUMBERS.OTHER_NUMBER"]
    other_number = CatalogOtherNumber.new
    other_number.catalog_id = obj.id
    other_number.other_number = row["OTHER_NUMBERS.OTHER_NUMBER"].strip rescue nil
    other_number.on_type = row["OTHER_NUMBERS.ON_TYPE"].strip.downcase rescue nil
    other_number.save
  end

  #link to site
  catsite = CatalogSite.new
  catsite.catalog_id = obj.id
  catsite.site_id = site.id
  catsite.save

  #link to place collected
  if !place_collected.nil?
    split_place = place_collected.split(": ")
    place = Place.where("broader_text LIKE '%#{split_place[0]}'").where(place1: split_place[1])
    if place.count == 1
      collplace = CatalogCollectionPlace.new
      collplace.catalog_id = obj.id
      collplace.place_id = place.first.id
      collplace.save
    end
  end

  #link to acquisition
  if !obj.credit_line.nil?
    acquisition_number = obj.credit_line
    acquisition = Acquisition.find_by_ref_number(acquisition_number) rescue nil
    if !acquisition.nil?
      acq_cat = AcquisitionCatalog.new
      acq_cat.catalog_id = obj.id
      acq_cat.acquisition_id = acquisition.id
      acq_cat.id_number = obj.catalog_number
      acq_cat.save
    end
  end

end