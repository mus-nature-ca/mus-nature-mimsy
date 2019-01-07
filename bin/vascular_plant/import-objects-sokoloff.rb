#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/!MXG Upload Sokoloff 2018.09b_Objects.txt"
log = "/Users/dshorthouse/Desktop/!MXG Upload Sokoloff 2018.09b_Objects-log.csv"

log_entries = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  puts row["CATALOGUE.ID_NUMBER"]
  
  if !Catalog.find_by_catalog_number(row["CATALOGUE.ID_NUMBER"]).nil?
    log_entries << [row["CATALOGUE.ID_NUMBER"], "catalog record already exists"]
    next
  end

  #Get the linked site
  site = nil
  site_id = row["SITES.SITE_ID"].strip rescue nil
  if !site_id.nil?
    site = Site.find_by_site_id(site_id)
    if site.nil?
      log_entries << [row["CATALOGUE.ID_NUMBER"], "SITE_ID #{site_id} does not exist"]
    end
  end

  #Get the linked placekey
  placekey = row["CATALOGUE.PLACEKEY"].strip rescue nil

  #create new catalog record
  obj = Catalog.new
  obj.catalog_number = row["CATALOGUE.ID_NUMBER"].strip
  obj.collection = row["CATALOGUE.CATEGORY1"].strip
  obj.scientific_name = row["CATALOGUE.ITEM_NAME"].strip
  obj.whole_part = row["CATALOGUE.WHOLE_PART"].strip rescue "whole"
  obj.item_count = row["CATALOGUE.ITEM_COUNT"].strip.to_i rescue nil
  obj.materials = row["CATALOGUE.MATERIALS"].strip rescue nil
  obj.description = row["CATALOGUE.DESCRIPTION"].strip rescue nil
  obj.collector = row["CATALOGUE.COLLECTOR"].strip rescue nil
  obj.date_collected = row["CATALOGUE.DATE_COLLECTED"].strip rescue nil
  obj.place_collected = row["CATALOGUE.PLACE_COLLECTED"].strip rescue nil
  obj.note = row["CATALOGUE.NOTE"].strip rescue nil
  obj.gbif = true
  obj.publish = true

  if !site.nil?
    obj.site = site.site_name
  end

  obj.save

  #Find object again - damn Oracle!
  obj = Catalog.find_by_catalog_number(obj.catalog_number)

  #create link to Taxonomy
  taxon = row["CATALOGUE.ITEMS_TAXONOMY.TAXONOMY"].strip
  tax = Taxon.find_by_scientific_name(taxon)
  #Find a variant if verbatim not found
  if tax.nil?
    tax = TaxonVariation.find_by_scientific_name(taxon).taxon rescue nil
  end
  if !tax.nil?
    obj_tax = CatalogTaxon.new
    obj_tax.taxon_id = tax.id
    obj_tax.catalog_id = obj.id
    obj_tax.attributor = row["CATALOGUE.ITEMS_TAXONOMY.ATTRIBUTOR"].strip rescue nil
    obj_tax.attrib_date = row["CATALOGUE.ITEMS_TAXONOMY.ATTRIB_DATE"].strip rescue nil
    obj_tax.save
  else
    log_entries << [obj.catalog_number, "taxon name #{taxon} not found in MIMSY"]
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
      if pers.nil?
        log_entries << [obj.catalog_number, "collector #{collector} not found"]
        next
      end
      cat_coll = CatalogCollector.new
      cat_coll.catalog_id = obj.id
      cat_coll.person_id = pers.id
      cat_coll.relationship = "collector"
      cat_coll.note = row["CATALOGUE.COLLECTOR_NOTE"].strip rescue nil
      cat_coll.save
    end
  end

  #create link to collected date
  if !obj.date_collected.nil?
    cd = CollectedDate.new
    cd.catalog_id = obj.id
    cd.date_text = obj.date_collected
    cd.collection_method = row["CATALOGUE.DATE_COLLECTED.COLLECTION_METHOD"].strip rescue nil
    cd.save
  end

  #link to site
  if !site.nil?
    catsite = CatalogSite.new
    catsite.catalog_id = obj.id
    catsite.site_id = site.id
    catsite.save
  end

  #link to place collected
  if !placekey.nil?
    collplace = CatalogCollectionPlace.new
    collplace.catalog_id = obj.id
    collplace.place_id = placekey
    collplace.save

    obj.reload
    obj.place_collected = Place.find(placekey).location_hierarchy
    obj.save
  end

  #other numbers
  (1..5).each do |num|
    number = row["CATALOGUE.OTHER_NUMBERS.OTHER_NUMBER#{num}"].strip rescue nil
    if !number.nil?
      other_number = CatalogOtherNumber.new
      other_number.catalog_id = obj.id
      other_number.other_number = number
      other_number.on_type = row["CATALOGUE.OTHER_NUMBERS.ON_TYPE#{num}"].strip rescue nil
      other_number.save
    end
  end

end

CSV.open(log, 'w') do |csv|
  csv << ["Item", "Note"]
  log_entries.each do |item|
    csv << item
  end
end