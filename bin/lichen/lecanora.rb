#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

speckey = 502817

taxon = Taxon.find(speckey)

taxon.catalogs.each do |catalog|
  if catalog.scientific_name != "Protoparmeliopsis muralis"
    if catalog.catalog_taxa.count > 1
      puts catalog.catalog_number.red
    else
      ct = catalog.catalog_taxa.first
      lm = catalog.names.where(scientific_name: "Lecanora muralis").first
      if !lm.nil?
        lm.prior_name = true
        if !ct.attributor.nil?
          lm.tna_type = "original identification"
        else
          lm.tna_type = "previous name"
        end
        lm.attributor = ct.attributor
        lm.attrib_date = ct.attrib_date
        lm.save
      end
      cn = CatalogName.new
      cn.catalog_id = catalog.id
      cn.item_name = "Protoparmeliopsis muralis"
      cn.tna_type = "item name"
      cn.attributor = "Deduke, Chris"
      cn.attrib_date = "2018-05-08"
      cn.note = "Taxonomic change without examination"
      cn.save
      ct.attributor = nil
      ct.attrib_date = nil
      ct.save
      catalog.scientific_name = "Protoparmeliopsis muralis"
      catalog.save
    end
  end
end