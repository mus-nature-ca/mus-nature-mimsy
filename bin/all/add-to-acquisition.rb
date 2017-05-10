#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

log = []

file = "/Users/dshorthouse/Desktop/acquisition.txt"

acquisition = Acquisition.find_by_ref_number("A2015.0010")

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  #create new catalog record
  obj = Catalog.new
  obj.catalog_number = row["ID_NUMBER"].strip
  obj.collection = row["CATEGORY1"].strip
  obj.scientific_name = row["ITEM_NAME"].strip
  obj.materials = row["MATERIALS"].strip rescue nil
  obj.item_count = row["ITEM_COUNT"].strip.to_i rescue nil
  obj.collector = row["COLLECTOR"].strip rescue nil
  obj.date_collected = row["DATE_COLLECTED"].strip rescue nil
  obj.place_collected = row["PLACE_COLLECTED"].strip rescue nil
  obj.credit_line = row["CREDIT_LINE"].strip rescue nil
  obj.gbif = true
  obj.publish = true
  obj.save

  #Find object again - damn Oracle!
  obj = Catalog.find_by_catalog_number(obj.catalog_number)

  #create Other Numbers
  other_number = row["OTHER_NUMBERS.OTHER_NUMBER"] rescue nil
  if !other_number.nil?
    con = CatalogOtherNumber.new
    con.catalog_id = obj.id
    con.other_number = other_number
    con.type = row["OTHER_NUMBERS.ON_TYPE"] rescue nil
    con.save
  end

  #create link to place collected
  pc = CatalogCollectionPlace.new
  pc.catalog_id = obj.id
  pc.place_id = row["PLACES.PLACEKEY"].strip rescue nil
  pc.save

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
    obj_tax.step = 1 if !row["ITEMS_TAXONOMY.TAXONOMY1"].nil?
    obj_tax.save
  else
    log << { catalog: obj.catalog_number, note: "#{taxon} missing" }
  end

  #Additional links to taxonomy
  (1..3).each do |num|
    taxon = row["ITEMS_TAXONOMY.TAXONOMY#{num}"].strip rescue nil
    if !taxon.nil?
      tax = Taxon.find_by_scientific_name(taxon)
      #Find a variant if verbatim not found
      if tax.nil?
        tax = TaxonVariation.find_by_scientific_name(taxon).taxon rescue nil
      end
      if !tax.nil?
        obj_tax = CatalogTaxon.new
        obj_tax.taxon_id = tax.id
        obj_tax.catalog_id = obj.id
        obj_tax.affiliation = row["ITEMS_TAXONOMY.AFFILIATION#{num}"] rescue nil
        obj_tax.step = num+1
        obj_tax.save
      else
        log << { catalog: obj.catalog_number, note: "#{taxon} missing" }
      end
    end
  end

  #create link to Catalog Name
  cn = CatalogName.new
  cn.scientific_name = obj.scientific_name
  cn.catalog_id = obj.id
  cn.save

  #create link to Person (collector)
  if !obj.collector.nil?
    #split by semi-colon
    people = obj.collector.split("; ")
    people.each do |person|
      pers = Person.find_by_preferred_name(person)
      if !pers.nil?
        cat_coll = CatalogCollector.new
        cat_coll.catalog_id = obj.id
        cat_coll.person_id = pers.id
        cat_coll.relationship = "collector"
        cat_coll.save
      else
        log << { catalog: obj.catalog_number, note: "#{person} missing" }
      end
    end
  end

  #create link to collected date
  cd = CollectedDate.new
  cd.catalog_id = obj.id
  cd.date_text = obj.date_collected
  cd.save

  #Add the acquisition catalog entry
  ac = AcquisitionCatalog.new
  ac.acquisition_id = acquisition.id
  ac.catalog_id = obj.id
  ac.id_number = obj.catalog_number
  ac.save

end

byebug
puts ""