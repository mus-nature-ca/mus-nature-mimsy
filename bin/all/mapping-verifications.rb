#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

COLLECTIONS = [
  "Fossil Vertebrate",
  "Lichen",
  "Vascular Plant",
  "Amphibian and Reptile",
  "Insect",
  "Annelid",
  "Bryophyte",
  "Crustacea",
  "Fish",
  "Mollusc",
  "Mammal",
  "NU Fossil Invertebrate",
  "NU Palaeobotany",
  "NU Fossil Vertebrate",
  "NU Archaeology",
  "General Invertebrate",
  "Bird",
  "Fossil Invertebrate",
  "Parasite",
  "Palaeobotany",
  "Palynology",
  "Alga"
]

ONE = {
  "Acquisition" => "ref_number",
  "Catalog" => "id_number",
  "Event" => "full_name",
  "Exhibition" => "full_name",
  "Facility" => "location",
  "Loan" => "loan_number",
  "Medium" => "media_id",
  "Person" => "preferred_name",
  "Place" => "place1",
  "Publication" => "title",
  "Site" => "site_id",
  "Thesaurus" => "term",
  "Taxon" => "scientific_name"
}

ONE_MANY = {
  "CatalogAccessory" => "accessory",
  "CatalogCollectionPlace" => "place",
  "CatalogComponent" => "component",
  "CatalogCulture" => "culture",
  "CatalogDescription" => "description",
  "CatalogInscription" => "inscription_text",
  "CatalogLegalStatus" => "legal_status",
  "CatalogMadePlace" => "place",
  "CatalogMaker" => "name",
  "CatalogMeasurement" => "measurement_type",
  "CatalogName" => "item_name",
  "CatalogOtherMeasurement" => "part_measured",
  "CatalogOtherNumber" => "other_number",
  "CatalogOwner" => "name",
  "CatalogPhysicalDescriptor" => "descriptor",
  "CatalogTerm" => "term",
  "CatalogTitle" => "title",
  "RelatedCatalog" => "object"
}

MANY_MANY = {
  "DisposalCatalog" => "ref_number",
  "CatalogEvent" => "full_name",
  "CatalogFacility" => "location",
  "CatalogMedium" => "media_id",
  "CatalogPerson" => "preferred_name",
  "CatalogPlace" => "placekey",
  "CatalogPublication" => "title",
  "CatalogSite" => "site_id",
  "CatalogSubject" => "subject",
  "CatalogTaxon" => "speckey"
}

ONE.each do |model, id|
  if model == "Catalog"
    COLLECTIONS.each do |collection|
      objects = []
      model.constantize.where(collection: collection).limit(1_000).find_each do |obj|
        objects << { id: obj.id, attr_size: obj.attributes.values.compact.size }
      end
      objects.sort_by { |hsh| hsh[:attr_size] }.reverse.first(6).each do |obj|
        puts "#{model}: " << model.constantize.find(obj[:id]).send(id.to_sym)
      end
    end
  else
    objects = []
    model.constantize.find_each do |obj|
      objects << { id: obj.id, attr_size: obj.attributes.values.compact.size }
    end
    objects.sort_by{|hsh| hsh[:attr_size] }.reverse.first(6).each do |obj|
      puts "#{model}: " << model.constantize.find(obj[:id]).send(id.to_sym)
    end
  end
end

ONE_MANY.each do |model, id|
  m = model.constantize
  key = m.attribute_names[m.custom_attribute_names.find_index("catalog_id")]
  catalogs = m.where.not(catalog_id: nil).where.not(catalog_id: 0).group(key.to_sym).order('count_all desc').count.first(2)
  puts catalogs.map{|o| {"id_number" => Catalog.find(o[0]).catalog_number, "#{m.name}" =>  m.where(mkey: o[0]).pluck(id.to_sym)}}
end

MANY_MANY.each do |model, id|
  m = model.constantize
  parent = model.sub("Catalog","")
  key = m.attribute_names[m.custom_attribute_names.find_index("catalog_id")]
  key2 = m.attribute_names[m.custom_attribute_names.find_index("#{parent}_id".downcase)]
  catalogs = m.where.not(catalog_id: nil).where.not(catalog_id: 0).group(key.to_sym).order('count_all desc').count.first(2)
  puts catalogs.map{|o| { "id_number" => Catalog.find(o[0]).catalog_number, "#{parent}" => m.where(catalog_id: o[0]).pluck(key2.to_sym).map{|s| parent.constantize.send("find_by_#{key2}".to_sym, s).send(id.to_sym)}}}
end