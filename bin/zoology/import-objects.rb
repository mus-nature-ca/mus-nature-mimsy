#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Concatenated MXG_Upload_ABS_v2_OBJECTS.txt"

log = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["ID_NUMBER"]

  #Get the linked site
  site = Site.find_by_site_id(row["ITEMS_SITES.SITE"].strip)

  #Get the linked placekey
  placekey = row["PLACES.PLACEKEY"].strip rescue nil

  #measurements
  measurement_type = row["MEASUREMENTS.MEASUREMENT_TYPE"].strip.downcase rescue nil
  measurement_dimension = row["MEASUREMENTS.DIMENSION1"].strip rescue nil
  measurement_unit = row["MEASUREMENTS.UNIT1"].strip.downcase rescue nil

  #create new catalog record
  obj = Catalog.new
  obj.catalog_number = row["ID_NUMBER"].strip
  obj.collection = row["CATEGORY1"].strip
  obj.scientific_name = row["ITEM_NAME"].strip
  obj.whole_part = row["WHOLE_PART"].strip rescue "part"
  obj.item_count = row["ITEM_COUNT"].strip.to_i rescue nil
  obj.materials = row["MATERIALS"].strip rescue nil
  obj.collector = row["COLLECTOR"].strip rescue nil
  obj.sex = row["CATALOGUE.SEX"].strip.downcase rescue nil
  obj.stage = row["CATALOGUE.STAGE"].strip rescue nil
  obj.date_collected = row["DATE_COLLECTED"].strip rescue nil
  obj.site = site.site_name
  obj.place_collected = row["PLACE_COLLECTED"].strip rescue nil
  obj.credit_line = row["CATALOGUE.CREDIT_LINE"].strip rescue nil
  obj.gbif = true
  obj.publish = row["CATALOGUE.PUBLISH"].strip rescue nil
  obj.note = row["NOTE"].strip rescue nil
  obj.description = row["CATALOGUE.DESCRIPTION"] rescue nil
  if !measurement_type.nil?
    obj[:measurements] = "whole: " + measurement_dimension.to_s + " " + measurement_unit
  end
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
    obj_tax.attrib_date = row["ITEMS_TAXONOMY.ATTRIB_DATE"].strip rescue nil
    obj_tax.save
  else
    log << [obj.catalog_number, "Taxon missing"]
  end

  #create link to Catalog Name
  cn = CatalogName.new
  cn.scientific_name = obj.scientific_name
  cn.catalog_id = obj.id
  cn.save

  #create link to Person (collector)
  if !obj.collector.nil?
    obj.collector.split("; ").each do |collector|
      pers = Person.find_by_preferred_name(collector)
      cat_coll = CatalogCollector.new
      cat_coll.catalog_id = obj.id
      cat_coll.person_id = pers.id
      cat_coll.relationship = "collector"
      cat_coll.save
    end
  end

  #create link to collected date
  cd = CollectedDate.new
  cd.catalog_id = obj.id
  cd.date_text = obj.date_collected
  cd.collection_method = row["DATE_COLLECTED.COLLECTION_METHOD"].strip rescue nil
  cd.save

  #link to site
  catsite = CatalogSite.new
  catsite.catalog_id = obj.id
  catsite.site_id = site.id
  catsite.save

  #link to place collected
  if !placekey.nil?
    collplace = CatalogCollectionPlace.new
    collplace.catalog_id = obj.id
    collplace.place_id = placekey
    collplace.save

    obj.reload
    obj.place_collected = obj.catalog_collection_places.first[:place]
    obj.save
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

  #other numbers
  other_number = row["OTHER_NUMBERS.OTHER_NUMBER"] rescue nil
  if !other_number.nil?
    on = CatalogOtherNumber.new
    on.other_number = other_number
    on.on_type = row["OTHER_NUMBERS.ON_TYPE"] rescue nil
    on.mkey = obj.id
    on.save
  end

  if !measurement_type.nil?
    cm = CatalogMeasurement.new
    cm.mkey = obj.id
    cm.part_measured = "whole"
    cm.measurement_type = measurement_type
    cm.dimension1 = measurement_dimension
    cm.unit1 = measurement_unit
    cm.save
  end

end

byebug
puts ""